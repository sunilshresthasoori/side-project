import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/story_detail_bloc.dart';
import '../../data/repositories/story_detail_mock_repository.dart';
import '../../domain/models/story_detail_model.dart';
import '../widgets/author_card.dart';
import '../widgets/comments_section.dart';
import '../widgets/photo_gallery_grid.dart';
import '../widgets/share_panel.dart';
import '../widgets/story_hero.dart';

class StoryDetailPage extends StatelessWidget {
  final String storyId;

  const StoryDetailPage({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StoryDetailBloc(repository: StoryDetailMockRepository())
        ..add(StoryDetailFetchEvent(storyId)),
      child: _StoryDetailView(storyId: storyId),
    );
  }
}

class _StoryDetailView extends StatelessWidget {
  final String storyId;

  const _StoryDetailView({required this.storyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<StoryDetailBloc, StoryDetailState>(
          builder: (context, state) {
            switch (state) {
              case StoryDetailLoading():
              case StoryDetailInitial():
                return const _StoryDetailSkeleton();
              case StoryDetailError():
                return _StoryDetailError(
                  message: state.message,
                  storyId: storyId,
                );
              case StoryDetailLoaded():
                return _StoryDetailContent(story: state.story);
              default:
                return const _StoryDetailSkeleton();
            }
          },
        ),
      ),
    );
  }
}

class _StoryDetailContent extends StatelessWidget {
  final StoryDetail story;

  const _StoryDetailContent({required this.story});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1000;
        final mainContent = _StoryBody(story: story);
        final sidePanel = _SidePanel(story: story);

        return SingleChildScrollView(
          child: Column(
            children: [
              StoryHero(
                story: story,
                onBack: () => Navigator.of(context).pop(),
                onShare: () => context
                    .read<StoryDetailBloc>()
                    .add(const StoryDetailShareEvent()),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: mainContent),
                          const SizedBox(width: 20),
                          SizedBox(width: 320, child: sidePanel),
                        ],
                      )
                    : Column(
                        children: [
                          mainContent,
                          const SizedBox(height: 20),
                          sidePanel,
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StoryBody extends StatelessWidget {
  final StoryDetail story;

  const _StoryBody({required this.story});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthorCard(story: story),
        const SizedBox(height: 18),
        SharePanel(
          onShare: () => context
              .read<StoryDetailBloc>()
              .add(const StoryDetailShareEvent()),
        ),
        const SizedBox(height: 18),
        _TagsRow(tags: story.tags),
        const SizedBox(height: 18),
        SectionHeader(title: 'Story', trailing: _MetaRow(story: story)),
        const SizedBox(height: 12),
        ...story.sections.expand(
          (section) => [
            Text(
              section.heading,
              style: GoogleFonts.syne(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            ...section.paragraphs.map(
              (paragraph) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  paragraph,
                  style: AppTypography.body(context),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
        const SizedBox(height: 8),
        SectionHeader(title: 'Photo Gallery'),
        const SizedBox(height: 12),
        PhotoGalleryGrid(images: story.galleryImagePaths),
        const SizedBox(height: 18),
        SectionHeader(title: 'Comments'),
        const SizedBox(height: 12),
        CommentsSection(
          comments: story.commentList,
          onPost: (text) => context
              .read<StoryDetailBloc>()
              .add(StoryDetailCommentPostedEvent(text)),
          onLike: (commentId) => context
              .read<StoryDetailBloc>()
              .add(StoryDetailCommentLikedEvent(commentId)),
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  final StoryDetail story;

  const _MetaRow({required this.story});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${story.readTimeMinutes} min read · ${_formatDate(story.date)}',
      style: AppTypography.caption(context),
    );
  }
}

class _TagsRow extends StatelessWidget {
  final List<String> tags;

  const _TagsRow({required this.tags});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags
            .map(
              (tag) => Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.saffron,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  tag.toUpperCase(),
                  style: GoogleFonts.syne(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SidePanel extends StatelessWidget {
  final StoryDetail story;

  const _SidePanel({required this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More from ${story.authorName}',
            style: GoogleFonts.syne(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...story.relatedStories.map(
            (related) => _RelatedStoryTile(related: related),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Text(
              'View all stories by ${story.authorName}',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.electricTeal,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RelatedStoryTile extends StatelessWidget {
  final RelatedStory related;

  const _RelatedStoryTile({required this.related});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: TrekAssetImage(
              assetPath: related.imagePath,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  related.title,
                  style: GoogleFonts.syne(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatDate(related.date)} · ${related.readTimeMinutes} min',
                  style: AppTypography.caption(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryDetailError extends StatelessWidget {
  final String message;
  final String storyId;

  const _StoryDetailError({required this.message, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, color: AppColors.textLight, size: 40),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTypography.body(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => context
                .read<StoryDetailBloc>()
                .add(StoryDetailFetchEvent(storyId)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: AppGradients.saffronAccent,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  'Retry',
                  style: AppTypography.button(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryDetailSkeleton extends StatelessWidget {
  const _StoryDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ShimmerBox(width: double.infinity, height: 320, radius: 0),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              children: [
                const ShimmerBox(width: double.infinity, height: 110, radius: 24),
                const SizedBox(height: 18),
                const ShimmerBox(width: double.infinity, height: 110, radius: 24),
                const SizedBox(height: 18),
                const ShimmerBox(width: double.infinity, height: 26, radius: 24),
                const SizedBox(height: 18),
                const ShimmerBox(width: double.infinity, height: 180, radius: 24),
                const SizedBox(height: 18),
                const ShimmerBox(width: double.infinity, height: 200, radius: 24),
              ],
            ),
          ),
        ],
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
