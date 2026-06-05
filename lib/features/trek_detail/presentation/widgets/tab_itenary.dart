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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Section header 
          Row(
            children: [
              Container(
                width: 3,
                height: 18,
                decoration: BoxDecoration(
                  gradient: AppGradients.saffronAccent,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Itinerary Field Log',
                style: GoogleFonts.syne(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...days.asMap().entries.map((e) {
            final index = e.key;
            final day = e.value;
            final isExpanded = index == expandedDayIndex;
            final isLast = index == days.length - 1;

            return _TimelineRow(
              day: day,
              index: index,
              isExpanded: isExpanded,
              isLast: isLast,
            );
          }),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// 
// One full row: node column + card, side by side.
// The node column's line segment stretches to match the card's intrinsic height.
// 

class _TimelineRow extends StatelessWidget {
  final ItineraryDay day;
  final int index;
  final bool isExpanded;
  final bool isLast;

  const _TimelineRow({
    required this.day,
    required this.index,
    required this.isExpanded,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: IntrinsicHeight(

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //  Node column 
            SizedBox(
              width: 36,
              child: _NodeColumn(
                isExpanded: isExpanded,
                isLast: isLast,
              ),
            ),
            const SizedBox(width: 10),

            //  Day card 
            Expanded(
              child: _DayCard(
                day: day,
                index: index,
                isExpanded: isExpanded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Node column: vertical line + circle node.
// Stretches to the full height of the sibling card via IntrinsicHeight.


class _NodeColumn extends StatefulWidget {
  final bool isExpanded;
  final bool isLast;

  const _NodeColumn({required this.isExpanded, required this.isLast});

  @override
  State<_NodeColumn> createState() => _NodeColumnState();
}

class _NodeColumnState extends State<_NodeColumn>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.isExpanded) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_NodeColumn old) {
    super.didUpdateWidget(old);
    if (widget.isExpanded && !old.isExpanded) {
      _pulse.repeat(reverse: true);
    } else if (!widget.isExpanded && old.isExpanded) {
      _pulse.stop();
      _pulse.reset();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Vertical line — full height of the row, hidden for last item
        if (!widget.isLast)
          Positioned.fill(
            top: 0,
            child: Center(
              child: Container(
                width: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.glacierBlue,
                      AppColors.glacierBlue.withValues(alpha: 0.2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        // For last item, draw only a top half-line
        if (widget.isLast)
          Positioned(
            top: 0,
            bottom: null,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 28, // reaches down to the node centre
              child: Center(
                child: Container(
                  width: 2,
                  color: AppColors.glacierBlue,
                ),
              ),
            ),
          ),

        // Node circle — pinned to top
        Positioned(
          top: 16,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulse ring
              if (widget.isExpanded)
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (_, __) => Transform.scale(
                    scale: 1.0 + _pulse.value * 0.65,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.saffron.withValues(
                          alpha: 0.28 * (1 - _pulse.value),
                        ),
                      ),
                    ),
                  ),
                ),
              // Circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: widget.isExpanded
                      ? AppGradients.saffronAccent
                      : const LinearGradient(
                    colors: [
                      AppColors.glacierBlue,
                      AppColors.deepGlacier,
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.glacierWhite,
                    width: 2.5,
                  ),
                  boxShadow: widget.isExpanded
                      ? [
                    BoxShadow(
                      color: AppColors.saffron.withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                      : [
                    BoxShadow(
                      color:
                      AppColors.glacierBlue.withValues(alpha: 0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// Day card


class _DayCard extends StatelessWidget {
  final ItineraryDay day;
  final int index;
  final bool isExpanded;

  const _DayCard({
    required this.day,
    required this.index,
    required this.isExpanded,
  });

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
            color: isExpanded
                ? AppColors.saffron.withValues(alpha: 0.35)
                : AppColors.divider,
            width: isExpanded ? 1.5 : 1,
          ),
          boxShadow: isExpanded ? AppShadows.soft : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //  Header 
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              day.title,
                              style: GoogleFonts.syne(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              day.subtitle,
                              style: GoogleFonts.dmSans(
                                fontSize: 10,
                                color: AppColors.textSub,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // HUD bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.snowFog,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      children: [
                        _HudCell(
                          icon: Icons.schedule_rounded,
                          iconColor: AppColors.glacierBlue,
                          value:
                          '${day.durationHours}–${day.durationHours + 1}h',
                        ),
                        _HudDivider(),
                        _HudCell(
                          icon: Icons.straighten_rounded,
                          iconColor: AppColors.electricTeal,
                          value: '${day.distanceKm}km',
                        ),
                        _HudDivider(),
                        _HudCell(
                          icon: Icons.filter_hdr_rounded,
                          iconColor: AppColors.saffron,
                          value: '${day.altitudeM}m',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //  Expandable body 
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOut,
              child: isExpanded
                  ? _DayBody(day: day)
                  : const SizedBox(width: double.infinity, height: 0),
            ),
          ],
        ),
      ),
    );
  }
}


// HUD helpers

class _HudCell extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;

  const _HudCell({
    required this.icon,
    required this.iconColor,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 11, color: iconColor),
          const SizedBox(width: 4),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textSub,
            ),
          ),
        ],
      ),
    );
  }
}

class _HudDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 14,
    color: AppColors.divider,
  );
}


// Expanded day body
// Note: NO Spacer, no unbounded children — safe inside IntrinsicHeight

class _DayBody extends StatelessWidget {
  final ItineraryDay day;
  const _DayBody({required this.day});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: 1, color: AppColors.divider),
        const SizedBox(height: 14),

        // Explorer's Notes
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "EXPLORER'S NOTES",
                style: GoogleFonts.dmSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 3,
                    height: null,
                    constraints: const BoxConstraints(minHeight: 40),
                    decoration: BoxDecoration(
                      gradient: AppGradients.saffronAccent,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      day.description,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppColors.textSub,
                        height: 1.65,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Checkpoints
        if (day.checkpoints.isNotEmpty) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded,
                    size: 12, color: AppColors.coral),
                const SizedBox(width: 6),
                Text(
                  'CHECKPOINTS ALONG THE WAY',
                  style: GoogleFonts.dmSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textLight,
                    letterSpacing: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
            child: _CheckpointGrid(checkpoints: day.checkpoints),
          ),
        ] else
          const SizedBox(height: 14),
      ],
    );
  }
}

// Checkpoint grid — manual 2-column layout instead of GridView.
// GridView inside IntrinsicHeight causes "unbounded height" errors.


class _CheckpointGrid extends StatelessWidget {
  final List<ItineraryCheckpoint> checkpoints;
  const _CheckpointGrid({required this.checkpoints});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < checkpoints.length; i += 2) {
      final left = checkpoints[i];
      final right = i + 1 < checkpoints.length ? checkpoints[i + 1] : null;
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _CheckpointCard(cp: left)),
            const SizedBox(width: 10),
            Expanded(
              child: right != null
                  ? _CheckpointCard(cp: right)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
      if (i + 2 < checkpoints.length) rows.add(const SizedBox(height: 10));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }
}

// Checkpoint card

class _CheckpointCard extends StatelessWidget {
  final ItineraryCheckpoint cp;
  const _CheckpointCard({required this.cp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.snowFog,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon + name
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppColors.saffron.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: const Icon(Icons.home_work_rounded,
                    size: 13, color: AppColors.saffron),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  cp.name,
                  style: GoogleFonts.syne(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            cp.description,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              color: AppColors.textSub,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          _CheckpointLedgerLine(
            icon: Icons.filter_hdr_rounded,
            iconColor: AppColors.electricTeal,
            value: '${cp.altitudeM}m',
            pillColor: AppColors.electricTeal,
          ),
          const SizedBox(height: 4),
          _CheckpointLedgerLine(
            icon: Icons.thermostat_rounded,
            iconColor: AppColors.glacierBlue,
            value: '${cp.tempMin}–${cp.tempMax}',
            pillColor: AppColors.glacierBlue,
          ),
          if (cp.hasWifi || cp.hasAtm || cp.hasCharging) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                if (cp.hasWifi) _FacilityBadge('WiFi', AppColors.glacierBlue),
                if (cp.hasAtm) _FacilityBadge('ATM', AppColors.saffron),
                if (cp.hasCharging)
                  _FacilityBadge('Charging', AppColors.electricTeal),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Text(
            'Details →',
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.coral,
            ),
          ),
        ],
      ),
    );
  }
}

// Checkpoint ledger line

class _CheckpointLedgerLine extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final Color pillColor;

  const _CheckpointLedgerLine({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.pillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 10, color: iconColor),
        const SizedBox(width: 4),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: CustomPaint(
              size: const Size(double.infinity, 1),
              painter: _DashedLinePainter(color: AppColors.divider),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: pillColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: pillColor.withValues(alpha: 0.22),
              width: 0.5,
            ),
          ),
          child: Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: pillColor,
            ),
          ),
        ),
      ],
    );
  }
}

// Facility badge

class _FacilityBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _FacilityBadge(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.11),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: color.withValues(alpha: 0.28)),
    ),
    child: Text(
      label,
      style: GoogleFonts.dmSans(
        fontSize: 8,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    ),
  );
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  _DashedLinePainter({
    required this.color,
    this.dashWidth = 3,
    this.dashSpace = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}