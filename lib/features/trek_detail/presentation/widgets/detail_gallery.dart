import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/trek_detail_bloc.dart';

class DetailGallery extends StatelessWidget {
  final List<String> images;
  final List<String> captions;
  final int currentIndex;
  final bool isSaved;

  const DetailGallery({
    super.key,
    required this.images,
    required this.captions,
    required this.currentIndex,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //  Main image area
        SizedBox(
          height: 300,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Hero image
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: TrekAssetImage(
                  key: ValueKey(currentIndex),
                  assetPath: images[currentIndex],
                  fit: BoxFit.cover,
                ),
              ),

              // Bottom gradient (caption legibility)
              Container(
                decoration: const BoxDecoration(
                  gradient: AppGradients.heroOverlay,
                ),
              ),

              // Top gradient (button legibility)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.55),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              //  Back button
              Positioned(
                top: 48,
                left: 16,
                child: _GlassIconBtn(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),

              //  Top-right actions (save + expand)
              Positioned(
                top: 48,
                right: 16,
                child: Row(
                  children: [
                    _GlassIconBtn(
                      icon: isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      iconColor: isSaved ? AppColors.saffron : Colors.white,
                      onTap: () => context
                          .read<TrekDetailBloc>()
                          .add(const TrekDetailSaveToggledEvent()),
                    ),
                    const SizedBox(width: 8),
                    _GlassIconBtn(
                      icon: Icons.open_in_full_rounded,
                      onTap: () => _openFullScreen(context),
                    ),
                  ],
                ),
              ),

              //  Left arrow
              if (currentIndex > 0)
                Positioned(
                  left: 14,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _GlassIconBtn(
                      icon: Icons.chevron_left_rounded,
                      size: 26,
                      onTap: () => context
                          .read<TrekDetailBloc>()
                          .add(TrekDetailGalleryChangedEvent(currentIndex - 1)),
                    ),
                  ),
                ),

              //  Right arrow
              if (currentIndex < images.length - 1)
                Positioned(
                  right: 14,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _GlassIconBtn(
                      icon: Icons.chevron_right_rounded,
                      size: 26,
                      onTap: () => context
                          .read<TrekDetailBloc>()
                          .add(TrekDetailGalleryChangedEvent(currentIndex + 1)),
                    ),
                  ),
                ),

              //  Caption + counter (bottom)
              Positioned(
                bottom: 14,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        captions[currentIndex],
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        '${currentIndex + 1} / ${images.length}',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        //  Thumbnail strip
        Container(
          height: 68,
          color: AppColors.cardWhite,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => context
                  .read<TrekDetailBloc>()
                  .add(TrekDetailGalleryChangedEvent(i)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: i == currentIndex
                        ? AppColors.saffron
                        : Colors.transparent,
                    width: 2.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm - 2),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      TrekAssetImage(assetPath: images[i], fit: BoxFit.cover),
                      if (i != currentIndex)
                        Container(color: Colors.black.withOpacity(0.25)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openFullScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullScreenGallery(
          images: images,
          captions: captions,
          initialIndex: currentIndex,
        ),
      ),
    );
  }
}

class _FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final List<String> captions;
  final int initialIndex;

  const _FullScreenGallery({
    required this.images,
    required this.captions,
    required this.initialIndex,
  });

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.images.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => InteractiveViewer(
                minScale: 1.0,
                maxScale: 3.0,
                child: Center(
                  child: TrekAssetImage(
                    assetPath: widget.images[i],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: _GlassIconBtn(
                icon: Icons.close_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.captions[_index],
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      '${_index + 1} / ${widget.images.length}',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  GLASS ICON BUTTON

class _GlassIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color iconColor;

  const _GlassIconBtn({
    required this.icon,
    required this.onTap,
    this.size = 20,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: iconColor, size: size),
      ),
    );
  }
}
