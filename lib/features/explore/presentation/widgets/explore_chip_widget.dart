import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/explore_bloc.dart';
import '../../domain/model/explore_model.dart';

//  MOOD CHIPS ROW 

class MoodChipsRow extends StatelessWidget {
  final String activeMood;

  const MoodChipsRow({super.key, required this.activeMood});

  static const _moods = [
    ('all',           'All'),
    ('highAltitude',  '🏔 High Altitude'),
    ('forest',        '🌿 Forest'),
    ('glacier',       '❄️ Glacier'),
    ('cultural',      '🏛 Cultural'),
    ('offBeat',       '🧭 Off-Beat'),
    ('familyFriendly','👨‍👩‍👧 Family'),
    ('photography',   '📸 Photography'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _moods.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final mood   = _moods[i];
          final active = mood.$1 == activeMood;
          return GestureDetector(
            onTap: () => context
                .read<ExploreBloc>()
                .add(ExploreMoodFilterChangedEvent(mood.$1)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: active ? AppGradients.saffronAccent : null,
                color: active ? null : AppColors.cardWhite,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: active ? Colors.transparent : AppColors.divider,
                ),
                boxShadow: active ? AppShadows.button : [],
              ),
              child: Text(
                mood.$2,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? Colors.white : AppColors.slateGray,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

//  SEASONAL ALERT BANNER 

class SeasonalAlertBanner extends StatelessWidget {
  const SeasonalAlertBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.electricTeal.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border(
            left: BorderSide(color: AppColors.electricTeal, width: 3),
          ),
        ),
        child: Row(
          children: [
            Text('🌸', style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Spring Season Open — Best time for EBC & Annapurna',
                style: GoogleFonts.dmSans(
                  fontSize: 12, fontWeight: FontWeight.w600,
                  color: AppColors.electricTeal,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => context
                  .read<ExploreBloc>()
                  .add(const ExploreSeasonalAlertDismissedEvent()),
              child: const Icon(Icons.close_rounded, size: 16, color: AppColors.electricTeal),
            ),
          ],
        ),
      ),
    );
  }
}

//  ACTIVE FILTERS ROW 

class ActiveFiltersRow extends StatelessWidget {
  final ExploreFilters filters;

  const ActiveFiltersRow({super.key, required this.filters});

  @override
  Widget build(BuildContext context) {
    final chips = filters.activeChips;
    if (chips.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ...chips.map((chip) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => context
                  .read<ExploreBloc>()
                  .add(ExploreSingleFilterRemovedEvent(chip.key)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.electricTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: AppColors.electricTeal.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      chip.label,
                      style: GoogleFonts.dmSans(
                        fontSize: 11, fontWeight: FontWeight.w600,
                        color: AppColors.electricTeal,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.close_rounded, size: 12, color: AppColors.electricTeal),
                  ],
                ),
              ),
            ),
          )),
          // Clear all
          GestureDetector(
            onTap: () => context
                .read<ExploreBloc>()
                .add(const ExploreFiltersResetEvent()),
            child: Center(
              child: Text(
                'Clear all',
                style: GoogleFonts.dmSans(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppColors.coral,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//  RECENTLY VIEWED ROW 

class RecentlyViewedRow extends StatelessWidget {
  final List<RecentlyViewedTrek> treks;

  const RecentlyViewedRow({super.key, required this.treks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSub),
              const SizedBox(width: 6),
              Text(
                'Continue Exploring',
                style: GoogleFonts.syne(
                  fontSize: 14, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: treks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => _RecentCard(trek: treks[i]),
          ),
        ),
      ],
    );
  }
}

class _RecentCard extends StatelessWidget {
  final RecentlyViewedTrek trek;
  const _RecentCard({required this.trek});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppRoutes.pushTrekDetail(context, trekId: trek.id),
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          color: AppColors.cardWhite,
          boxShadow: AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 72,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  TrekAssetImage(assetPath: trek.imagePath, fit: BoxFit.cover),
                  Positioned(
                    top: 6, left: 6,
                    child: DifficultyBadge(level: trek.difficulty),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
              child: Text(
                trek.title,
                style: GoogleFonts.syne(
                  fontSize: 10, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}