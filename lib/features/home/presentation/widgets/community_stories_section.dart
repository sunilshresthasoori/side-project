import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/home_bloc.dart';
import '../../domain/models/trek_models.dart';

class CommunityStoriesSection extends StatelessWidget {
  final List<CommunityStory> stories;

  const CommunityStoriesSection({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: stories
            .map((story) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _StoryCard(story: story),
                ))
            .toList(),
      ),
    );
  }
}

// SINGLE STORY CARD
class _StoryCard extends StatelessWidget {
  final CommunityStory story;

  const _StoryCard({required this.story});

  Color get _tagColor {
    switch (story.tags) {
      case 'Trek Report':
        return AppColors.deepGlacier;
      case 'Culture':
        return AppColors.saffron;
      case 'Tips':
        return AppColors.electricTeal;
      case 'Gear':
        return AppColors.slateGray;
      default:
        return AppColors.glacierBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Image ─
          SizedBox(
            height: 240,
            child: Stack(
              fit: StackFit.expand,
              children: [
                TrekAssetImage(
                  assetPath: story.imagePath,
                  fit: BoxFit.cover,
                ),

                // Bottom scrim
                Container(
                  decoration: const BoxDecoration(
                    gradient: AppGradients.cardBottom,
                  ),
                ),

                // Tag badge (topleft)
                Positioned(
                  top: 14,
                  left: 14,
                  child: TagBadge(
                    label: story.tags,
                    color: _tagColor,
                    textColor: AppColors.cardWhite,
                  ),
                ),

                // Title on image (bottom)
                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  child: Text(
                    story.title,
                    style: GoogleFonts.syne(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          //  Text Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Text(
              story.excerpt,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: AppColors.textSub,
                height: 1.6,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          //  Footer ─
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.electricTeal.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: TrekAssetImage(
                      assetPath: story.authorAvatarPath,
                      fit: BoxFit.cover,
                      width: 36,
                      height: 36,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Author + time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.authorName,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        story.timeAgo,
                        style: AppTypography.caption(context),
                      ),
                    ],
                  ),
                ),

                // Like button + count
                _LikeButton(story: story),

                const SizedBox(width: 16),

                // Comment count
                Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 16,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _formatCount(story.comments),
                      style: AppTypography.caption(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          //  Read More Link
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Read full story',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.electricTeal,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: AppColors.electricTeal,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// LIKE BUTTON (optimistic update via BLoC)

class _LikeButton extends StatelessWidget {
  final CommunityStory story;

  const _LikeButton({required this.story});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<HomeBloc>().add(ToggleFavouriteTrekStoryEvent(story.id)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.coral.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_rounded,
              size: 16,
              color: AppColors.coral,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            _formatCount(story.likes),
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.coral,
            ),
          ),
        ],
      ),
    );
  }
}

// FORMAT LARGE NUMBERS

String _formatCount(int count) {
  if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
  return count.toString();
}

// SKELETON

class CommunityStoriesSkeleton extends StatelessWidget {
  const CommunityStoriesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(
          2,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: ShimmerBox(
              width: double.infinity,
              height: 340,
              radius: 16,
            ),
          ),
        ),
      ),
    );
  }
}
