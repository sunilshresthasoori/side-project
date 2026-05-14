import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../domain/models/community_model.dart';

class StoryGridCard extends StatelessWidget {
  final CommunityStory story;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;

  const StoryGridCard({
    super.key,
    required this.story,
    this.onTap,
    this.onBookmark,
  });

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
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
                    left: 10,
                    top: 10,
                    child: DifficultyBadge(level: story.difficulty),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: _ContentTypeBadge(label: story.contentType),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: GestureDetector(
                      onTap: onBookmark,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(220),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Icon(
                          story.isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: AppColors.deepGlacier,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  _Avatar(path: story.authorAvatarPath),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              story.authorName,
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const _VerifiedBadge(),
                          ],
                        ),
                        Text(
                          _timeAgo(story.date),
                          style: AppTypography.caption(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Text(
                story.title,
                style: GoogleFonts.syne(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              child: Text(
                story.excerpt,
                style: AppTypography.body(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: GestureDetector(
                onTap: onTap,
                child: Text(
                  story.location,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.electricTeal,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Row(
                children: [
                  _Metric(
                    icon: Icons.favorite_rounded,
                    color: AppColors.coral,
                    value: story.likes,
                  ),
                  const SizedBox(width: 12),
                  _Metric(
                    icon: Icons.chat_bubble_outline_rounded,
                    color: AppColors.textLight,
                    value: story.comments,
                  ),
                  const SizedBox(width: 12),
                  _Metric(
                    icon: Icons.ios_share_rounded,
                    color: AppColors.textLight,
                    value: story.shares,
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

class _Avatar extends StatelessWidget {
  final String path;

  const _Avatar({required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.electricTeal.withAlpha(60),
          width: 1.5,
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
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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

class _Metric extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int value;

  const _Metric({required this.icon, required this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          _formatCount(value),
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSub,
          ),
        ),
      ],
    );
  }
}

String _formatCount(int count) {
  if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
  return count.toString();
}

String _timeAgo(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inDays >= 1) return '${diff.inDays}d ago';
  if (diff.inHours >= 1) return '${diff.inHours}h ago';
  return '${diff.inMinutes}m ago';
}
