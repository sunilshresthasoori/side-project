import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../data/repository/strategy_remote_repository.dart';
import '../../domain/models/strategy_model.dart';
import '../../domain/models/trek_detail_model.dart';
import 'strategy_sections/strategy_hero.dart';
import 'strategy_sections/strategy_snapshot.dart';
import 'strategy_sections/strategy_about.dart';
import 'strategy_sections/strategy_highlights.dart';
import 'strategy_sections/strategy_timeline.dart';
import 'strategy_sections/strategy_route.dart';
import 'strategy_sections/strategy_altitude.dart';
import 'strategy_sections/strategy_packing_guide.dart';
import 'strategy_sections/strategy_facts.dart';

class TabStrategy extends StatefulWidget {
  final TrekDetail detail;

  const TabStrategy({super.key, required this.detail});

  @override
  State<TabStrategy> createState() => _TabStrategyState();
}

class _TabStrategyState extends State<TabStrategy> {
  late StrategyRemoteDataSource _dataSource;
  StrategyDetail? _selectedStrategyDetail;
  List<StrategyItinerary>? _itineraries;
  List<StrategyWaypoint>? _waypoints;
  List<StrategyPacking>? _packings;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _dataSource = StrategyRemoteDataSource();
    _loadStrategy();
  }

  Future<void> _loadStrategy() async {
    try {
      setState(() => _isLoading = true);

      // Fetch strategies list
      final strategies = await _dataSource.fetchStrategies(widget.detail.id);
      if (strategies.isEmpty) {
        setState(() {
          _error = 'No strategies available';
          _isLoading = false;
        });
        return;
      }

      // Randomly select one strategy
      final selected = (strategies..shuffle()).first;

      // Fetch all strategy data in parallel
      final results = await Future.wait([
        _dataSource.fetchStrategyDetail(selected.id),
        _dataSource.fetchItineraries(selected.id),
        _dataSource.fetchWaypoints(selected.id),
        _dataSource.fetchPackings(selected.id),
      ]);

      setState(() {
        _selectedStrategyDetail = results[0] as StrategyDetail;
        _itineraries = results[1] as List<StrategyItinerary>;
        _waypoints = results[2] as List<StrategyWaypoint>;
        _packings = results[3] as List<StrategyPacking>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _LoadingState();
    }

    if (_error != null || _selectedStrategyDetail == null) {
      return _ErrorState(error: _error ?? 'Failed to load strategy');
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // SECTION 1: Trek Strategy Hero
          StrategyHero(strategy: _selectedStrategyDetail!),
          const SizedBox(height: 24),

          // SECTION 2: Trek Snapshot
          StrategySnapshot(strategy: _selectedStrategyDetail!),
          const SizedBox(height: 24),

          // SECTION 3: About This Route
          StrategyAbout(strategy: _selectedStrategyDetail!),
          const SizedBox(height: 24),

          // SECTION 4: Highlights
          if (_selectedStrategyDetail!.highlights.isNotEmpty) ...[
            StrategyHighlights(highlights: _selectedStrategyDetail!.highlights),
            const SizedBox(height: 24),
          ],

          // SECTION 5: Journey Timeline
          if (_itineraries != null && _itineraries!.isNotEmpty) ...[
            StrategyTimeline(itineraries: _itineraries!),
            const SizedBox(height: 24),
          ],

          // SECTION 6: Route Map Story
          if (_waypoints != null && _waypoints!.isNotEmpty) ...[
            StrategyRoute(waypoints: _waypoints!),
            const SizedBox(height: 24),
          ],

          // SECTION 7: Altitude Journey
          if (_waypoints != null && _waypoints!.isNotEmpty) ...[
            StrategyAltitude(waypoints: _waypoints!),
            const SizedBox(height: 24),
          ],

          // SECTION 8: Packing Guide
          if (_packings != null && _packings!.isNotEmpty) ...[
            StrategyPackingGuide(packings: _packings!),
            const SizedBox(height: 24),
          ],

          // SECTION 9: Expedition Facts
          StrategyFacts(strategy: _selectedStrategyDetail!),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// LOADING STATE

class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const ShimmerBox(width: double.infinity, height: 200, radius: 16),
          const SizedBox(height: 20),
          const ShimmerBox(width: double.infinity, height: 140, radius: 16),
          const SizedBox(height: 20),
          const ShimmerBox(width: double.infinity, height: 180, radius: 16),
          const SizedBox(height: 20),
          const ShimmerBox(width: double.infinity, height: 160, radius: 16),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ERROR STATE

class _ErrorState extends StatelessWidget {
  final String error;
  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.landscape_rounded, size: 48, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(
            'Strategy unavailable',
            style: GoogleFonts.syne(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: AppTypography.body(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: AppGradients.saffronAccent,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.syne(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





