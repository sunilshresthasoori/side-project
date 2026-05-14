import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/community_bloc.dart';
import '../../data/repositories/community_mock_repository.dart';
import '../../domain/models/community_model.dart';
import '../widgets/featured_story_card.dart';
import '../widgets/filter_panel.dart';
import '../widgets/story_grid_card.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommunityBloc(repository: CommunityMockRepository())
        ..add(const CommunityFetchEvent()),
      child: const _CommunityView(),
    );
  }
}

class _CommunityView extends StatelessWidget {
  const _CommunityView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CommunityBloc, CommunityState>(
          builder: (context, state) {
            switch (state) {
              case CommunityLoading():
              case CommunityInitial():
                return const _CommunitySkeleton();
              case CommunityError():
                return _CommunityError(message: state.message);
              case CommunityLoaded():
                return _CommunityContent(state: state);
              default:
                return const _CommunitySkeleton();
            }
          },
        ),
      ),
    );
  }
}

class _CommunityContent extends StatelessWidget {
  final CommunityLoaded state;

  const _CommunityContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final hasStories = state.stories.isNotEmpty;
    final featured = hasStories
        ? state.stories.firstWhere(
            (story) => story.isFeatured,
            orElse: () => state.stories.first,
          )
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 980;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BreadcrumbBar(onShare: () {}),
              const SizedBox(height: 18),
              _SearchBar(
                onChanged: (value) => context
                    .read<CommunityBloc>()
                    .add(CommunitySearchChangedEvent(value)),
              ),
              const SizedBox(height: 18),
              if (featured != null) ...[
                FeaturedStoryCard(
                  story: featured,
                  onTap: () => AppRoutes.pushStoryDetail(
                    context,
                    storyId: featured.id,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: hasStories
                          ? _StoryGrid(stories: state.stories)
                          : const _EmptyState(),
                    ),
                    const SizedBox(width: 18),
                    SizedBox(
                      width: 280,
                      child: FilterPanel(
                        filters: state.filters,
                        locations: state.locations,
                        difficulties: state.difficulties,
                        contentTypes: state.contentTypes,
                        sortOptions: state.sortOptions,
                        onChanged: (filters) => context
                            .read<CommunityBloc>()
                            .add(CommunityFilterChangedEvent(filters)),
                        onReset: () => context
                            .read<CommunityBloc>()
                            .add(const CommunityFilterResetEvent()),
                      ),
                    ),
                  ],
                )
              else ...[
                FilterPanel(
                  filters: state.filters,
                  locations: state.locations,
                  difficulties: state.difficulties,
                  contentTypes: state.contentTypes,
                  sortOptions: state.sortOptions,
                  onChanged: (filters) => context
                      .read<CommunityBloc>()
                      .add(CommunityFilterChangedEvent(filters)),
                  onReset: () => context
                      .read<CommunityBloc>()
                      .add(const CommunityFilterResetEvent()),
                ),
                const SizedBox(height: 18),
                hasStories
                    ? _StoryGrid(stories: state.stories)
                    : const _EmptyState(),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Icon(Icons.travel_explore, color: AppColors.textLight, size: 36),
          const SizedBox(height: 10),
          Text(
            'No stories match these filters yet.',
            style: AppTypography.body(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BreadcrumbBar extends StatelessWidget {
  final VoidCallback onShare;

  const _BreadcrumbBar({required this.onShare});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Home > Community > Stories',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSub,
            ),
          ),
        ),
        GestureDetector(
          onTap: onShare,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: AppGradients.saffronAccent,
              borderRadius: BorderRadius.circular(AppRadius.full),
              boxShadow: AppShadows.button,
            ),
            child: Row(
              children: [
                const Icon(Icons.add, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Share Story',
                  style: AppTypography.button(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.full),
        boxShadow: AppShadows.card,
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search stories, treks, or guides',
          prefixIcon: const Icon(Icons.search_rounded),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _StoryGrid extends StatelessWidget {
  final List<CommunityStory> stories;

  const _StoryGrid({required this.stories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final story = stories[index];
        return StoryGridCard(
          story: story,
          onTap: () => AppRoutes.pushStoryDetail(
            context,
            storyId: story.id,
          ),
          onBookmark: () => context
              .read<CommunityBloc>()
              .add(CommunityStoryBookmarkToggled(story.id)),
        );
      },
    );
  }
}

class _CommunityError extends StatelessWidget {
  final String message;

  const _CommunityError({required this.message});

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
                  .read<CommunityBloc>()
                  .add(const CommunityFetchEvent()),
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

class _CommunitySkeleton extends StatelessWidget {
  const _CommunitySkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: ShimmerBox(width: double.infinity, height: 18),
              ),
              const SizedBox(width: 16),
              ShimmerBox(width: 140, height: 40, radius: 999),
            ],
          ),
          const SizedBox(height: 18),
          const ShimmerBox(width: double.infinity, height: 52, radius: 999),
          const SizedBox(height: 18),
          const ShimmerBox(width: double.infinity, height: 190, radius: 24),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                child: ShimmerBox(width: double.infinity, height: 400, radius: 24),
              ),
              const SizedBox(width: 18),
              ShimmerBox(width: 240, height: 400, radius: 24),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (_, __) => const ShimmerBox(
              width: double.infinity,
              height: 260,
              radius: 24,
            ),
          ),
        ],
      ),
    );
  }
}
