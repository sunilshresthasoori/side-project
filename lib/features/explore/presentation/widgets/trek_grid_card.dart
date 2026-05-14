import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/explore_bloc.dart';
import '../../domain/model/explore_model.dart';

class TrekGridCard extends StatelessWidget {
  final ExploreTrek trek;

  const TrekGridCard({super.key, required this.trek});

  @override
  Widget build(BuildContext context) {
    const imgH = 180.0;

    return GestureDetector(
      onTap: () => AppRoutes.pushTrekDetail(context, trekId: trek.id),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Image
            SizedBox(
              height: imgH,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  TrekAssetImage(assetPath: trek.imagePath, fit: BoxFit.cover),

                  // Gradient scrim
                  Container(
                    decoration:
                        const BoxDecoration(gradient: AppGradients.cardBottom),
                  ),

                  // Difficulty badge (top-left)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: DifficultyBadge(level: trek.difficulty),
                  ),

                  // Trending badge (top-center) — only on trending treks
                  if (trek.isTrending)
                    Positioned(
                      top: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.coral, Color(0xFFFF4757)],
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            '🔥 Trending',
                            style: GoogleFonts.syne(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Bookmark (top-right)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => context
                          .read<ExploreBloc>()
                          .add(ExploreTrekBookmarkToggled(trek.id)),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: trek.isBookmarked
                              ? AppColors.saffron.withOpacity(0.9)
                              : Colors.black.withOpacity(0.45),
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Icon(
                          trek.isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),

                  // Bottom: name + region
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trek.title,
                          style: GoogleFonts.syne(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                size: 10, color: AppColors.coral),
                            const SizedBox(width: 2),
                            Text(
                              trek.region,
                              style: GoogleFonts.dmSans(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //  Card body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stat pills row
                    Row(
                      children: [
                        _StatPill(Icons.calendar_today_rounded,
                            '${trek.durationDays}d', AppColors.glacierBlue),
                        const SizedBox(width: 6),
                        _StatPill(
                            Icons.filter_hdr_rounded,
                            '${(trek.maxAltitudeM / 1000).toStringAsFixed(1)}km',
                            AppColors.electricTeal),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Rating
                    StarRow(rating: trek.rating, reviewCount: trek.reviewCount),

                    const SizedBox(height: 8),

                    // Highlight tags
                    _HighlightTags(tags: trek.highlightTags),

                    const Spacer(),

                    // View Details button
                    GestureDetector(
                      onTap: () =>
                          AppRoutes.pushTrekDetail(context, trekId: trek.id),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          gradient: AppGradients.saffronAccent,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Center(
                          child: Text(
                            'View Details',
                            style: GoogleFonts.syne(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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

//  STAT PILL

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatPill(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 3),
            Text(label,
                style: GoogleFonts.dmSans(
                    fontSize: 10, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      );
}

//  HIGHLIGHT TAGS

class _HighlightTags extends StatelessWidget {
  final List<String> tags;

  const _HighlightTags({required this.tags});

  @override
  Widget build(BuildContext context) {
    final shown = tags.take(2).toList();
    final extra = tags.length - shown.length;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...shown.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.snowFog,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.divider),
              ),
              child: Text(tag,
                  style: GoogleFonts.dmSans(
                      fontSize: 9, color: AppColors.textSub)),
            )),
        if (extra > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.glacierBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('+$extra more',
                style: GoogleFonts.dmSans(
                    fontSize: 9, color: AppColors.glacierBlue)),
          ),
      ],
    );
  }
}
