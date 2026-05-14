
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../bloc/trek_detail_bloc.dart';
import '../../domain/models/trek_detail_model.dart';

class TabItinerary extends StatelessWidget {
  final List<ItineraryDay> days;
  final int expandedDayIndex;

  const TabItinerary({
    super.key,
    required this.days,
    required this.expandedDayIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ...days.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _DayCard(
              day: e.value,
              index: e.key,
              isExpanded: e.key == expandedDayIndex,
            ),
          )),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

//  DAY CARD 

class _DayCard extends StatelessWidget {
  final ItineraryDay day;
  final int index;
  final bool isExpanded;

  const _DayCard({required this.day, required this.index, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read<TrekDetailBloc>()
          .add(TrekDetailItineraryDayTappedEvent(index)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isExpanded ? AppColors.saffron.withOpacity(0.4) : AppColors.divider,
            width: isExpanded ? 1.5 : 1,
          ),
          boxShadow: isExpanded ? AppShadows.soft : AppShadows.card,
        ),
        child: Column(
          children: [
            //  Header row 
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Day number bubble
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      gradient: isExpanded
                          ? AppGradients.saffronAccent
                          : const LinearGradient(
                        colors: [AppColors.glacierBlue, AppColors.deepGlacier],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.dayNumber}',
                        style: GoogleFonts.syne(
                          fontSize: 15, fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Title + subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day.title,
                          style: GoogleFonts.syne(
                            fontSize: 14, fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary, height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          day.subtitle,
                          style: GoogleFonts.dmSans(
                            fontSize: 11, color: AppColors.textSub,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Quick meta
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _MetaPill(Icons.access_time_rounded, '${day.durationHours}–${day.durationHours + 1}h'),
                      const SizedBox(height: 4),
                      _MetaPill(Icons.straighten_rounded,   '${day.distanceKm}km'),
                      const SizedBox(height: 4),
                      _MetaPill(Icons.filter_hdr_rounded,   '${day.altitudeM}m'),
                    ],
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),

            //  Expandable body 
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 280),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: _DayBody(day: day),
            ),
          ],
        ),
      ),
    );
  }
}

//  DAY BODY (expanded content) 

class _DayBody extends StatelessWidget {
  final ItineraryDay day;
  const _DayBody({required this.day});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider
        Container(height: 1, color: AppColors.divider),

        // Description
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Text(
            day.description,
            style: GoogleFonts.dmSans(
              fontSize: 13, color: AppColors.textSub,
              height: 1.65,
            ),
          ),
        ),

        // Checkpoints header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 14, color: AppColors.coral),
              const SizedBox(width: 6),
              Text(
                'Checkpoints Along The Way',
                style: GoogleFonts.syne(
                  fontSize: 13, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // Checkpoint cards in 2-column grid
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: day.checkpoints.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (_, i) => _CheckpointCard(cp: day.checkpoints[i]),
          ),
        ),
      ],
    );
  }
}

//  CHECKPOINT CARD 

class _CheckpointCard extends StatelessWidget {
  final ItineraryCheckpoint cp;
  const _CheckpointCard({required this.cp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.snowFog,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // House icon + name
          Row(
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: AppColors.saffron.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: const Icon(Icons.home_work_rounded, size: 15, color: AppColors.saffron),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  cp.name,
                  style: GoogleFonts.syne(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            cp.description,
            style: GoogleFonts.dmSans(
              fontSize: 10, color: AppColors.textSub, height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          // Altitude
          Row(
            children: [
              const Icon(Icons.filter_hdr_rounded, size: 11, color: AppColors.electricTeal),
              const SizedBox(width: 3),
              Text('${cp.altitudeM}m', style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.electricTeal)),
              const SizedBox(width: 8),
              const Icon(Icons.thermostat_rounded, size: 11, color: AppColors.glacierBlue),
              const SizedBox(width: 3),
              Text('${cp.tempMin}–${cp.tempMax}', style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.glacierBlue, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          // Facility badges
          Wrap(
            spacing: 4, runSpacing: 4,
            children: [
              if (cp.hasWifi)     _FacilityBadge('WiFi',     AppColors.glacierBlue),
              if (cp.hasAtm)      _FacilityBadge('ATM',      AppColors.saffron),
              if (cp.hasCharging) _FacilityBadge('Charging', AppColors.electricTeal),
            ],
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Click for details →',
              style: GoogleFonts.dmSans(
                fontSize: 10, fontWeight: FontWeight.w700,
                color: AppColors.coral,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FacilityBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _FacilityBadge(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(
      label,
      style: GoogleFonts.dmSans(
        fontSize: 8, fontWeight: FontWeight.w700, color: color,
      ),
    ),
  );
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaPill(this.icon, this.label);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 10, color: AppColors.textLight),
      const SizedBox(width: 3),
      Text(label, style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.textSub)),
    ],
  );
}