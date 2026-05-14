import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../domain/models/story_detail_model.dart';

class StoryHero extends StatelessWidget {
  final StoryDetail story;
  final VoidCallback onBack;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;

  const StoryHero({
    super.key,
    required this.story,
    required this.onBack,
    this.onShare,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 320,
          width: double.infinity,
          child: TrekAssetImage(
            assetPath: story.imagePath,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: _GlassIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: onBack,
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            children: [
              _GlassIconButton(
                icon: Icons.bookmark_border_rounded,
                onTap: onBookmark,
              ),
              const SizedBox(width: 10),
              _GlassIconButton(
                icon: Icons.ios_share_rounded,
                onTap: onShare,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _GlassIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(160),
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: Colors.white.withAlpha(120)),
            ),
            child: Icon(icon, color: AppColors.deepGlacier, size: 18),
          ),
        ),
      ),
    );
  }
}
