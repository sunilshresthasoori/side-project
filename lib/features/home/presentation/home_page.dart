import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trekkers_odyssey_v2/features/home/presentation/widgets/category_grid.dart';
import 'package:trekkers_odyssey_v2/features/home/presentation/widgets/community_stories_section.dart';
import 'package:trekkers_odyssey_v2/features/home/presentation/widgets/featured_treks_section.dart';
import 'package:trekkers_odyssey_v2/features/home/presentation/widgets/hero_section.dart';
import 'package:trekkers_odyssey_v2/features/home/presentation/widgets/quick_stat_banner.dart';
import 'package:trekkers_odyssey_v2/features/home/presentation/widgets/trek_bottom_nav_bar.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../app/routes/app_routes.dart';
import '../bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navIndex = 0;

  void _handleNavTap(int i) {
    if (i == 1) {
      AppRoutes.pushExplore(context);
      return;
    }

    if (i == 3) {
      Navigator.of(context).pushNamed(AppRoutes.community);
      return;
    }

    setState(() => _navIndex = i);
  }

  @override
  Widget build(BuildContext context) {
    // Provide HomeBloc scoped to this page
    return BlocProvider(
      create: (_) => HomeBloc()..add(const FetchHomeDataEvent()),
      child: _HomeView(
        navIndex: _navIndex,
        onNavTap: _handleNavTap,
      ),
    );
  }
}

// HOME VIEW
class _HomeView extends StatelessWidget {
  final int navIndex;
  final ValueChanged<int> onNavTap;

  const _HomeView({required this.navIndex, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: AppColors.glacierWhite,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: TrekBottomNav(
        currentIndex: navIndex,
        onTap: onNavTap,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              //  Sticky App Bar
              SliverToBoxAdapter(
                child: TrekAppBar(
                  onNotificationTap: () {},
                  onMenuTap: () {},
                ),
              ),

              //  Hero
              SliverToBoxAdapter(
                child: HeroSection(
                  onSearchChanged: (q) =>
                      context.read<HomeBloc>().add(SearchHomeEvent(q)),
                  onExploreTap: () => AppRoutes.pushExplore(context),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              //  EXPLORE TREKS
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Explore Treks',
                  actionLabel: 'All →',
                  onAction: () => onNavTap(1),
                ),
              ),

              // Category 2×2 grid
              SliverToBoxAdapter(
                child: switch (state) {
                  HomeLoaded s => CategoryGrid(
                      categories: s.categories,
                      onCategoryTap: (_) => onNavTap(1),
                    ),
                  HomeLoading() => const CategoryGridSkeleton(),
                  _ => const SizedBox.shrink(),
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 28)),

              // Quick stats banner
              const SliverToBoxAdapter(child: QuickStatsBanner()),

              const SliverToBoxAdapter(
                  child: SizedBox(
                height: 30,
                width: 40,
              )),
              //  FEATURED TREKS
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Featured Treks',
                  actionLabel: 'All →',
                  onAction: () => onNavTap(1),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),

              SliverToBoxAdapter(
                child: switch (state) {
                  HomeLoaded s => FeaturedTreksSection(
                      treks: s.featuredTreks,
                    ),
                  HomeLoading() => const FeaturedTreksSkeleton(),
                  _ => const SizedBox.shrink(),
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              //  COMMUNITY STORIES
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Community Stories',
                  actionLabel: 'View all',
                  onAction: () =>
                      Navigator.of(context).pushNamed(AppRoutes.community),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              SliverToBoxAdapter(
                child: switch (state) {
                  HomeLoaded s => CommunityStoriesSection(
                      stories: s.communityStories,
                    ),
                  HomeLoading() => const CommunityStoriesSkeleton(),
                  HomeError e => _ErrorState(message: e.message),
                  _ => const SizedBox.shrink(),
                },
              ),

              //  Footer CTA Banner
              const SliverToBoxAdapter(child: _FooterCtaBanner()),

              // Bottom padding for safe area
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}

// ERROR STATE

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded,
              size: 48, color: AppColors.textLight),
          const SizedBox(height: 12),
          Text(
            'Something went wrong',
            style: AppTypography.headline(context),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTypography.body(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<HomeBloc>().add(const FetchHomeDataEvent()),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _FooterCtaBanner extends StatelessWidget {
  const _FooterCtaBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D1117), Color(0xFF1A3A5C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Festival accent strip
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              gradient: AppGradients.saffronAccent,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Share Your\nTrek Story.',
            style: AppTypography.display2(context).copyWith(
              color: Colors.white,
              fontSize: 28,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Inspire thousands of future trekkers.\nYour story matters.',
            style: AppTypography.body(context).copyWith(
              color: Colors.white60,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              // Primary CTA
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: AppGradients.saffronAccent,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      boxShadow: AppShadows.button,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.edit_rounded,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Write a Story',
                          style: AppTypography.button(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Secondary ghost button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                    ),
                  ),
                  child: Text(
                    'Learn More',
                    style: AppTypography.button(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
