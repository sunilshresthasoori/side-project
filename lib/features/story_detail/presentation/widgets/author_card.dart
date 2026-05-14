import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../domain/models/story_detail_model.dart';

class AuthorCard extends StatelessWidget {
  final StoryDetail story;
  final VoidCallback? onFollow;

  const AuthorCard({super.key, required this.story, this.onFollow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.electricTeal.withAlpha(60),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: TrekAssetImage(
                assetPath: story.authorAvatarPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      story.authorName,
                      style: GoogleFonts.syne(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const _VerifiedBadge(),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  story.authorBio,
                  style: AppTypography.body(context),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_formatCount(story.authorFollowers)} followers · ${_formatDate(story.date)} · ${story.readTimeMinutes} min read',
                  style: AppTypography.caption(context),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onFollow,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: AppGradients.saffronAccent,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                'Follow',
                style: AppTypography.button(context),
              ),
            ),
          ),
        ],
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
