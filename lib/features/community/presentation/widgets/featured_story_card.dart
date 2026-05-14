import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../domain/models/community_model.dart';

class FeaturedStoryCard extends StatelessWidget {
  final CommunityStory story;
  final VoidCallback? onTap;

  const FeaturedStoryCard({super.key, required this.story, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(
              width: 170,
              height: 190,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  TrekAssetImage(
                    assetPath: story.imagePath,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: AppGradients.cardBottom,
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: _FeaturedBadge(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _ContentTypeBadge(label: story.contentType),
                        const SizedBox(width: 8),
                        DifficultyBadge(level: story.difficulty),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      story.title,
                      style: GoogleFonts.syne(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      story.excerpt,
                      style: AppTypography.body(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    _AuthorRow(story: story),
                    const SizedBox(height: 12),
                    _MetricsRow(story: story),
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

class _FeaturedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppGradients.saffronAccent,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            'Featured Story',
            style: GoogleFonts.syne(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentTypeBadge extends StatelessWidget {
  final String label;

  const _ContentTypeBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.saffron,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.syne(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  final CommunityStory story;

  const _AuthorRow({required this.story});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Avatar(path: story.authorAvatarPath),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    story.authorName,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const _VerifiedBadge(),
                ],
              ),
              Text(
                '${_formatDate(story.date)} · ${story.trekName}',
                style: AppTypography.caption(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricsRow extends StatelessWidget {
  final CommunityStory story;

  const _MetricsRow({required this.story});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Metric(
          icon: Icons.favorite_rounded,
          color: AppColors.coral,
          value: story.likes,
        ),
        const SizedBox(width: 16),
        _Metric(
          icon: Icons.chat_bubble_outline_rounded,
          color: AppColors.textLight,
          value: story.comments,
        ),
        const SizedBox(width: 16),
        _Metric(
          icon: Icons.ios_share_rounded,
          color: AppColors.textLight,
          value: story.shares,
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int value;

  const _Metric({required this.icon, required this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          _formatCount(value),
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSub,
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String path;

  const _Avatar({required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.electricTeal.withAlpha(60),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: TrekAssetImage(assetPath: path, fit: BoxFit.cover),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF2ECC71).withAlpha(30),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        'Verified',
        style: GoogleFonts.dmSans(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2ECC71),
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

String _formatCount(int count) {
  if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
  return count.toString();
}
