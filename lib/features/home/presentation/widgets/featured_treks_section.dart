import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/home_bloc.dart';
import '../../domain/models/trek_models.dart';

class FeaturedTreksSection extends StatelessWidget {
  final List<FeaturedTrek> treks;

  const FeaturedTreksSection({super.key, required this.treks});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: treks.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) => _TrekCard(trek: treks[index]),
      ),
    );
  }
}

//SINGLE TREK CARD
class _TrekCard extends StatelessWidget {
  final FeaturedTrek trek;

  const _TrekCard({required this.trek});

  List<String> get _imageList {
    if (trek.imagePaths.isNotEmpty) return trek.imagePaths;
    final fallback = trek.imagePath.trim();
    return fallback.isNotEmpty ? [fallback] : [''];
  }

  String _formatCoord(double? value) => (value ?? 0).toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppRoutes.pushTrekDetail(context, trekId: trek.id),
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          color: AppColors.cardWhite,
          boxShadow: AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Area
            SizedBox(
              height: 156,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _SlidingImages(urls: _imageList),
                  // Bottom scrim
                  Container(
                    decoration: const BoxDecoration(
                      gradient: AppGradients.cardBottom,
                    ),
                  ),

                  // Top badges row
                  Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DifficultyBadge(level: trek.destinationType),
                        _FavoriteButton(trek: trek),
                      ],
                    ),
                  ),

                  // Altitude (bottom-left)
                  Positioned(
                    bottom: 10,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: AppGradients.saffronAccent,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        '${trek.altitudeM}m',
                        style: GoogleFonts.fredoka(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Rating placeholder (bottom-right)
                  Positioned(
                    bottom: 10,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: StarRow(
                        rating: 0.0,
                        starColor: AppColors.saffron,
                        textColor: Colors.white70,
                        reviewCount: trek.views,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //  Info Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      trek.name,
                      style: GoogleFonts.syne(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Region
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            size: 12, color: AppColors.coral),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            trek.district,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: AppColors.textSub,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Lat / Lng
                    Text(
                      'Lat ${_formatCoord(trek.latitude)} • Lng ${_formatCoord(trek.longitude)}',
                      style: AppTypography.caption(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Stats row: views | altitude
                    Row(
                      children: [
                        _StatPill(
                          icon: Icons.visibility_rounded,
                          label: '${trek.views}',
                          color: AppColors.glacierBlue,
                        ),
                        const SizedBox(width: 8),
                        _StatPill(
                          icon: Icons.filter_hdr_rounded,
                          label:
                              '${(trek.altitudeM / 1000).toStringAsFixed(1)}km',
                          color: AppColors.electricTeal,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Reviews count
                    Text(
                      '${trek.views.toString().replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (m) => '${m[1]},',
                          )} reviews',
                      style: AppTypography.caption(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//FAVORITE BUTTON

class _FavoriteButton extends StatelessWidget {
  final FeaturedTrek trek;

  const _FavoriteButton({required this.trek});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final willBeFavorite = !trek.isFavourite;
        context.read<HomeBloc>().add(ToggleFavouriteTrekIconEvent(trek.id));
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                willBeFavorite
                    ? 'Added to favorites'
                    : 'Removed from favorites',
              ),
              backgroundColor: AppColors.deepGlacier,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          );
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: trek.isFavourite
              ? AppColors.coral.withValues(alpha: 0.9)
              : Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
        child: Icon(
          trek.isFavourite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          color: Colors.white,
          size: 17,
        ),
      ),
    );
  }
}

//INLINE STAT PILL

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatPill(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// SKELETON

class FeaturedTreksSkeleton extends StatelessWidget {
  const FeaturedTreksSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, __) => const ShimmerBox(
          width: 220,
          height: 310,
          radius: 16,
        ),
      ),
    );
  }
}

//slider
class _SlidingImages extends StatefulWidget {
  final List<String> urls;
  const _SlidingImages({required this.urls});

  @override
  State<_SlidingImages> createState() => _SlidingImagesState();
}

class _SlidingImagesState extends State<_SlidingImages> {
  int _current = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.urls.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 2), (_) {
        if (mounted) {
          setState(() =>
              _current = (_current + 1) % widget.urls.length);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.urls.isEmpty || widget.urls.first.isEmpty) {
      return const ColoredBox(color: Colors.grey);
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFF0D1117)),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: SizedBox.expand(
            key: ValueKey(widget.urls[_current]),
            child: TrekAssetImage(
              assetPath: widget.urls[_current],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}