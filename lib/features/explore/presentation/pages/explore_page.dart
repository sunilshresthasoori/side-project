import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/explore_bloc.dart';

import '../../domain/model/explore_model.dart';
import '../widgets/explore_chip_widget.dart';
import '../widgets/explore_top_widget.dart';
import '../widgets/trek_grid_card.dart';

import '../widgets/trek_map_view.dart';

class ExplorePage extends StatefulWidget {
  final String? initialMood; // passed from home category tap

  const ExplorePage({super.key, this.initialMood});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = ExploreBloc()..add(const ExploreFetchEvent());
        if (widget.initialMood != null) {
          bloc.add(ExploreMoodFilterChangedEvent(widget.initialMood!));
        }
        return bloc;
      },
      child: const _ExploreView(),
    );
  }
}

class _ExploreView extends StatefulWidget {
  const _ExploreView();

  @override
  State<_ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<_ExploreView> {
  // Animated subtitle ticker
  int    _subtitleIndex = 0;
  Timer? _subtitleTimer;
  static const _subtitles = ['240+ verified trails', '18K+ trekkers', '8 countries covered', '4.8★ avg rating'];

  @override
  void initState() {
    super.initState();
    _subtitleTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) setState(() => _subtitleIndex = (_subtitleIndex + 1) % _subtitles.length);
    });
  }

  @override
  void dispose() {
    _subtitleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: AppColors.glacierWhite,
      body: BlocBuilder<ExploreBloc, ExploreState>(
        builder: (context, state) {
          return NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (context, _) => [
              //  Sticky header 
              SliverAppBar(
                pinned: true,
                floating: true,
                backgroundColor: AppColors.glacierWhite,
                elevation: 0,
                scrolledUnderElevation: 1,
                automaticallyImplyLeading: false,
                toolbarHeight: 0,
                flexibleSpace: Container(), // completely custom
              ),
            ],
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                //  Page header 
                SliverToBoxAdapter(
                  child: _PageHeader(
                    subtitleText: _subtitles[_subtitleIndex],
                    activeView: state is ExploreLoaded ? state.activeView : ExploreView.grid,
                    activeSort: state is ExploreLoaded ? state.activeSort : ExploreSort.mostPopular,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 14)),

                //  Search bar 
                SliverToBoxAdapter(
                  child: ExploreSearchBar(
                    activeFilterCount: state is ExploreLoaded
                        ? state.activeFilters.activeCount
                        : 0,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                //  Mood chips 
                SliverToBoxAdapter(
                  child: MoodChipsRow(
                    activeMood: state is ExploreLoaded ? state.activeMood : 'all',
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                //  Seasonal alert (dismissible) 
                if (state is ExploreLoaded && state.seasonalAlertVisible)
                  const SliverToBoxAdapter(child: SeasonalAlertBanner()),

                if (state is ExploreLoaded && state.seasonalAlertVisible)
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),

                //  Active filter chips 
                if (state is ExploreLoaded && !state.activeFilters.isEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        ActiveFiltersRow(filters: state.activeFilters),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),

                //  Body: loading / grid / map / error / empty 
                switch (state) {
                  ExploreInitial() || ExploreLoading() => SliverToBoxAdapter(child: _LoadingSkeleton()),
                  ExploreError e  => SliverToBoxAdapter(child: _ErrorView(message: e.message)),
                  ExploreLoaded s => s.activeView == ExploreView.map
                      ? _MapBody(state: s)
                      : _GridBody(state: s),
                  // TODO: Handle this case.
                  ExploreState() => throw UnimplementedError(),
                },
              ],
            ),
          );
        },
      ),
    );
  }
}

//  PAGE HEADER 

class _PageHeader extends StatelessWidget {
  final String      subtitleText;
  final ExploreView activeView;
  final ExploreSort activeSort;

  const _PageHeader({required this.subtitleText, required this.activeView, required this.activeSort});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover Treks',
                    style: GoogleFonts.syne(
                      fontSize: 26, fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary, height: 1.1,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      subtitleText,
                      key: ValueKey(subtitleText),
                      style: GoogleFonts.dmSans(
                        fontSize: 12, color: AppColors.textSub,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              // Grid / Map toggle
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  boxShadow: AppShadows.card,
                ),
                child: Row(
                  children: [
                    _ViewToggleBtn(
                      icon: Icons.grid_view_rounded,
                      label: 'Grid',
                      isActive: activeView == ExploreView.grid,
                      onTap: () => context.read<ExploreBloc>().add(const ExploreViewToggledEvent(ExploreView.grid)),
                    ),
                    _ViewToggleBtn(
                      icon: Icons.map_rounded,
                      label: 'Map',
                      isActive: activeView == ExploreView.map,
                      onTap: () => context.read<ExploreBloc>().add(const ExploreViewToggledEvent(ExploreView.map)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ViewToggleBtn extends StatelessWidget {
  final IconData icon;
  final String   label;
  final bool     isActive;
  final VoidCallback onTap;

  const _ViewToggleBtn({required this.icon, required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: isActive ? AppGradients.saffronAccent : null,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: isActive ? Colors.white : AppColors.textLight),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: isActive ? Colors.white : AppColors.textLight)),
        ],
      ),
    ),
  );
}

//  GRID BODY 

class _GridBody extends StatelessWidget {
  final ExploreLoaded state;
  const _GridBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final treks     = state.filteredTreks;
    final trekOfWeek = state.allTreks.where((t) => t.isTrekOfWeek).firstOrNull;

    if (treks.isEmpty) return SliverToBoxAdapter(child: _EmptyState());

    return SliverList(
      delegate: SliverChildListDelegate([
        // Recently viewed
        if (state.recentlyViewed.isNotEmpty) ...[
          const SizedBox(height: 6),
          RecentlyViewedRow(treks: state.recentlyViewed),
          const SizedBox(height: 20),
        ],

        // Result count + sort
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${treks.length} trek${treks.length == 1 ? '' : 's'} found',
                style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              _SortDropdown(activeSort: state.activeSort),
            ],
          ),
        ),

        // Trek of week banner (before grid)
        if (trekOfWeek != null) ...[
          TrekOfWeekBanner(trek: trekOfWeek),
          const SizedBox(height: 16),
        ],

        // Staggered 2-column grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _StaggeredGrid(treks: treks),
        ),

        const SizedBox(height: 32),
      ]),
    );
  }
}

//  GRID
// Renders treks in pairs with consistent card sizing.

class _StaggeredGrid extends StatelessWidget {
  final List<ExploreTrek> treks;
  const _StaggeredGrid({required this.treks});

  @override
  Widget build(BuildContext context) {
    final rows = (treks.length / 2).ceil();
    return Column(
      children: List.generate(rows, (rowIdx) {
        final left  = treks[rowIdx * 2];
        final right = rowIdx * 2 + 1 < treks.length ? treks[rowIdx * 2 + 1] : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: TrekGridCard(trek: left)),
                const SizedBox(width: 12),
                Expanded(
                  child: right != null
                      ? TrekGridCard(trek: right)
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

//  SORT DROPDOWN 

class _SortDropdown extends StatelessWidget {
  final ExploreSort activeSort;
  const _SortDropdown({required this.activeSort});

  static const _labels = {
    ExploreSort.mostPopular:  'Most Popular',
    ExploreSort.highestRated: 'Highest Rated',
    ExploreSort.shortestFirst:'Shortest First',
    ExploreSort.longestFirst: 'Longest First',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ExploreSort>(
          value: activeSort,
          isDense: true,
          style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          items: ExploreSort.values.map((s) => DropdownMenuItem(
            value: s,
            child: Text(_labels[s] ?? s.name),
          )).toList(),
          onChanged: (s) {
            if (s != null) context.read<ExploreBloc>().add(ExploreSortChangedEvent(s));
          },
        ),
      ),
    );
  }
}

//  MAP BODY 

SliverToBoxAdapter _MapBody({required ExploreLoaded state}) {
  return SliverToBoxAdapter(
    child: SizedBox(
      height: 520,
      child: TrekMapView(
        treks: state.filteredTreks,
        selectedTrekId: state.selectedMapTrekId,
      ),
    ),
  );
}

//  EMPTY STATE 

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          CustomPaint(size: const Size(120, 80), painter: _MountainSilhouette()),
          const SizedBox(height: 20),
          Text('No treks found', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('Try adjusting your filters or search term', style: AppTypography.body(context), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => context.read<ExploreBloc>().add(const ExploreFiltersResetEvent()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
              decoration: BoxDecoration(
                gradient: AppGradients.saffronAccent,
                borderRadius: BorderRadius.circular(AppRadius.full),
                boxShadow: AppShadows.button,
              ),
              child: Text('Clear Filters', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MountainSilhouette extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.iceBlue
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.2, size.height * 0.3)
      ..lineTo(size.width * 0.35, size.height * 0.55)
      ..lineTo(size.width * 0.5, size.height * 0.1)
      ..lineTo(size.width * 0.65, size.height * 0.5)
      ..lineTo(size.width * 0.8, size.height * 0.3)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

//  LOADING SKELETON 

class _LoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const ShimmerBox(width: double.infinity, height: 110, radius: 16),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: ShimmerBox(width: double.infinity, height: 260, radius: 16)),
              SizedBox(width: 12),
              Expanded(child: ShimmerBox(width: double.infinity, height: 200, radius: 16)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(child: ShimmerBox(width: double.infinity, height: 200, radius: 16)),
              SizedBox(width: 12),
              Expanded(child: ShimmerBox(width: double.infinity, height: 260, radius: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

//  ERROR VIEW 

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 56, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text('Failed to load treks', style: AppTypography.headline(context)),
          const SizedBox(height: 8),
          Text(message, style: AppTypography.body(context), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.read<ExploreBloc>().add(const ExploreFetchEvent()),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}