import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/trek_detail_bloc.dart';
import '../../domain/models/trek_detail_model.dart';

class DetailHeader extends StatelessWidget {
  final TrekDetail detail;

  const DetailHeader({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardWhite,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Breadcrumb ─
          Row(
            children: [
              Text('Home',
                  style: AppTypography.caption(context)
                      .copyWith(color: AppColors.glacierBlue)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.chevron_right,
                    size: 12, color: AppColors.textLight),
              ),
              Text('Discover Treks',
                  style: AppTypography.caption(context)
                      .copyWith(color: AppColors.glacierBlue)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.chevron_right,
                    size: 12, color: AppColors.textLight),
              ),
              Expanded(
                child: Text(
                  detail.title,
                  style: AppTypography.caption(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Title ─
          Text(
            detail.title,
            style: GoogleFonts.syne(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.15,
            ),
          ),

          const SizedBox(height: 8),

          // ── Region + difficulty
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 14, color: AppColors.coral),
              const SizedBox(width: 4),
              Text(
                '${detail.region}, ${detail.country}',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSub,
                ),
              ),
              const Spacer(),
              DifficultyBadge(level: detail.difficulty),
            ],
          ),

          const SizedBox(height: 16),

          // ── Rating summary row
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.saffron.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.saffron, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      detail.ratingSummary.overall.toStringAsFixed(1),
                      style: GoogleFonts.syne(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.saffron,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${detail.ratingSummary.totalReviews} reviews)',
                      style: AppTypography.caption(context),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Trek stat chips row ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _StatChip(
                    icon: Icons.calendar_today_rounded,
                    value: '${detail.durationDays} Days',
                    color: AppColors.glacierBlue),
                const SizedBox(width: 10),
                _StatChip(
                    icon: Icons.filter_hdr_rounded,
                    value:
                        '${(detail.maxAltitudeM / 1000).toStringAsFixed(1)}km Alt.',
                    color: AppColors.electricTeal),
                const SizedBox(width: 10),
                _StatChip(
                    icon: Icons.straighten_rounded,
                    value: '${detail.distanceKm}km',
                    color: AppColors.coral),
                const SizedBox(width: 10),
                _StatChip(
                    icon: Icons.wb_sunny_rounded,
                    value: detail.bestSeason,
                    color: AppColors.saffron),
              ],
            ),
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _StatChip(
      {required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailTabBar extends StatelessWidget {
  final TrekDetailTab activeTab;

  const DetailTabBar({super.key, required this.activeTab});

  static const _tabs = [
    (TrekDetailTab.overview, 'Overview'),
    (TrekDetailTab.routeMap, 'Route Map'),
    (TrekDetailTab.itinerary, 'Itinerary'),
    (TrekDetailTab.hotels, 'Hotels'),
    (TrekDetailTab.reviews, 'Reviews'),
    (TrekDetailTab.safety, 'Safety'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _tabs.map((t) {
            final isActive = t.$1 == activeTab;
            return GestureDetector(
              onTap: () => context
                  .read<TrekDetailBloc>()
                  .add(TrekDetailTabChangedEvent(t.$1)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isActive ? AppColors.saffron : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    t.$2,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? AppColors.saffron : AppColors.textSub,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
