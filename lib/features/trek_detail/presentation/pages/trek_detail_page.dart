import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/trek_detail_bloc.dart';
import '../widgets/detail_gallery.dart';
import '../widgets/detail_header.dart';
import '../widgets/tab_hotel.dart';
import '../widgets/tab_itenary.dart';
import '../widgets/tab_overview.dart';
import '../widgets/tab_route_map.dart';

import '../widgets/tab_reviews.dart';
import '../widgets/tab_safety.dart';

class TrekDetailPage extends StatelessWidget {
  final String trekId;

  const TrekDetailPage({super.key, required this.trekId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrekDetailBloc()..add(TrekDetailFetchEvent(trekId)),
      child: const _TrekDetailView(),
    );
  }
}

class _TrekDetailView extends StatelessWidget {
  const _TrekDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrekDetailBloc, TrekDetailState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.glacierWhite,
          body: switch (state) {
            TrekDetailInitial() => _LoadingView(),
            TrekDetailLoading() => _LoadingView(),
            TrekDetailError e => _ErrorView(message: e.message),
            TrekDetailLoaded s => _LoadedView(state: s),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

//  LOADED VIEW

class _LoadedView extends StatelessWidget {
  final TrekDetailLoaded state;
  const _LoadedView({required this.state});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        //  Gallery (scrolls away)
        SliverToBoxAdapter(
          child: DetailGallery(
            images: state.detail.galleryImages,
            captions: state.detail.galleryCaptions,
            currentIndex: state.galleryIndex,
            isSaved: state.detail.isSaved,
          ),
        ),

        //  Header: title, region, rating, stats
        SliverToBoxAdapter(
          child: DetailHeader(detail: state.detail),
        ),

        //  Sticky Tab Bar
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyTabDelegate(activeTab: state.activeTab),
        ),

        //  Tab content body
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _TabBody(state: state),
          ),
        ),
      ],
    );
  }
}

//  TAB BODY SWITCHER

class _TabBody extends StatelessWidget {
  final TrekDetailLoaded state;
  const _TabBody({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.activeTab) {
      case TrekDetailTab.overview:
        return TabOverview(detail: state.detail);
      case TrekDetailTab.routeMap:
        return TabRouteMap(routePoints: state.detail.routePoints);
      case TrekDetailTab.itinerary:
        return TabItinerary(
          days: state.detail.itinerary,
          expandedDayIndex: state.expandedDayIndex,
        );
      case TrekDetailTab.hotels:
        return TabHotels(hotels: state.detail.hotels);
      case TrekDetailTab.reviews:
        return TabReviews(
          summary: state.detail.ratingSummary,
          reviews: state.detail.reviews,
        );
      case TrekDetailTab.safety:
        return TabSafety(
          permits: state.detail.permits,
          packingList: state.detail.packingList,
        );
    }
  }
}

//  STICKY TAB DELEGATE

class _StickyTabDelegate extends SliverPersistentHeaderDelegate {
  final TrekDetailTab activeTab;
  const _StickyTabDelegate({required this.activeTab});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                    color: AppColors.slateGray.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ]
            : [],
      ),
      // child: DetailTabBar(activeTab: activeTab),
    );
  }

  @override
  double get maxExtent => 48;
  @override
  double get minExtent => 48;
  @override
  bool shouldRebuild(_StickyTabDelegate old) => old.activeTab != activeTab;
}

//  LOADING VIEW

class _LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
           ShimmerBox(width: double.infinity, height: 300, radius: 0),
           SizedBox(height: 16),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ShimmerBox(width: double.infinity, height: 28, radius: 8),
                 SizedBox(height: 10),
                ShimmerBox(width: 200, height: 16, radius: 8),
                 SizedBox(height: 20),
                ShimmerBox(width: double.infinity, height: 80, radius: 12),
                 SizedBox(height: 16),
                ShimmerBox(width: double.infinity, height: 160, radius: 12),
              ],
            ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 60, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text('Could not load trek', style: AppTypography.headline(context)),
            const SizedBox(height: 8),
            Text(message,
                style: AppTypography.body(context),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
