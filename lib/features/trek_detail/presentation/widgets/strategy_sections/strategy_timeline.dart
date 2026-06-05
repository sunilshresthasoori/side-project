import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../app/theme/app_theme.dart';
import '../../../domain/models/strategy_model.dart';

class StrategyTimeline extends StatefulWidget {
  final List<StrategyItinerary> itineraries;

  const StrategyTimeline({super.key, required this.itineraries});

  @override
  State<StrategyTimeline> createState() => _StrategyTimelineState();
}

class _StrategyTimelineState extends State<StrategyTimeline>
    with TickerProviderStateMixin {
  final Map<int, bool> _expandedDays = {};
  final Map<int, AnimationController> _pulseControllers = {};

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.itineraries.length; i++) {
      _pulseControllers[i] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1400),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    for (final c in _pulseControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("STRETEGY TIMELINE REBUILT!");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
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

        // Timeline body — continuous line via IntrinsicHeight + left border
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: continuous vertical line + nodes
              SizedBox(
                width: 48,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Continuous line
                    Positioned.fill(
                      top: 20,
                      bottom: 20,
                      child: Center(
                        child: Container(
                          width: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.glacierBlue.withValues(alpha: 0.15),
                                AppColors.glacierBlue,
                                AppColors.glacierBlue.withValues(alpha: 0.15),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Nodes for each day
                    Column(
                      children: List.generate(widget.itineraries.length, (i) {
                        final isExpanded = _expandedDays[i] ?? false;
                        final isLast = i == widget.itineraries.length - 1;
                        return _TimelineNode(
                          index: i,
                          dayNumber: widget.itineraries[i].dayNumber,
                          isExpanded: isExpanded,
                          isLast: isLast,
                          pulseController: _pulseControllers[i]!,
                          itemHeight: _itemHeight(i),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Right: day cards
              Expanded(
                child: Column(
                  children: List.generate(widget.itineraries.length, (i) {
                    final day = widget.itineraries[i];
                    final isExpanded = _expandedDays[i] ?? false;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _expandedDays[i] = !isExpanded),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            color: AppColors.cardWhite,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            border: Border.all(
                              color: isExpanded
                                  ? AppColors.saffron.withValues(alpha: 0.35)
                                  : AppColors.divider,
                              width: isExpanded ? 1.5 : 1,
                            ),
                            boxShadow:
                            isExpanded ? AppShadows.soft : AppShadows.card,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Header ──────────────────────────────────
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Route line
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            day.startPoint,
                                            style: GoogleFonts.syne(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.textPrimary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 11,
                                            color: AppColors.textLight,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            day.endPoint,
                                            style: GoogleFonts.syne(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.textPrimary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Spacer(),
                                        AnimatedRotation(
                                          turns: isExpanded ? 0.5 : 0,
                                          duration:
                                          const Duration(milliseconds: 250),
                                          child: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 18,
                                            color: AppColors.textLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // ── Consolidated HUD ──────────────────
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: AppColors.snowFog,
                                        borderRadius: BorderRadius.circular(
                                            AppRadius.sm),
                                      ),
                                      child: Row(
                                        children: [
                                          _HudCell(
                                            icon: Icons.schedule_rounded,
                                            iconColor: AppColors.glacierBlue,
                                            value: day.duration,
                                          ),
                                          _HudDivider(),
                                          _HudCell(
                                            icon: Icons.trending_up_rounded,
                                            iconColor: AppColors.electricTeal,
                                            value: '+${day.altitudeGain}m',
                                          ),
                                          _HudDivider(),
                                          _HudCell(
                                            icon: Icons.trending_down_rounded,
                                            iconColor: AppColors.coral,
                                            value: '-${day.altitudeLoss}m',
                                          ),
                                          _HudDivider(),
                                          _HudCell(
                                            icon: Icons.thermostat_rounded,
                                            iconColor: AppColors.saffron,
                                            value: '${day.temperature}°C',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ── Expanded Body ────────────────────────────
                              AnimatedCrossFade(
                                duration: const Duration(milliseconds: 280),
                                crossFadeState: isExpanded
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                firstChild: const SizedBox.shrink(),
                                secondChild: _ExpandedBody(day: day),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Approximate card heights so node positions feel accurate along the line
  double _itemHeight(int index) {
    final isExpanded = _expandedDays[index] ?? false;
    return isExpanded ? 280 : 115;
  }
}

// ────────────────────────────────────────────────────────────────
// Timeline node (circle + optional glow)
// ────────────────────────────────────────────────────────────────

class _TimelineNode extends StatelessWidget {
  final int index;
  final int dayNumber;
  final bool isExpanded;
  final bool isLast;
  final AnimationController pulseController;
  final double itemHeight;

  const _TimelineNode({
    required this.index,
    required this.dayNumber,
    required this.isExpanded,
    required this.isLast,
    required this.pulseController,
    required this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Each node sits at the top of its card row
    return SizedBox(
      height: itemHeight + 12, // matches card + bottom padding
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulse ring when expanded
              if (isExpanded)
                AnimatedBuilder(
                  animation: pulseController,
                  builder: (_, __) {
                    final scale =
                        1.0 + pulseController.value * 0.55;
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.saffron
                              .withValues(alpha: 0.25 * (1 - pulseController.value)),
                        ),
                      ),
                    );
                  },
                ),
              // Node circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isExpanded
                      ? AppGradients.saffronAccent
                      : const LinearGradient(
                    colors: [
                      AppColors.glacierBlue,
                      AppColors.deepGlacier,
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.cardWhite,
                    width: 2.5,
                  ),
                  boxShadow: isExpanded
                      ? [
                    BoxShadow(
                      color: AppColors.saffron.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                      : [
                    BoxShadow(
                      color: AppColors.glacierBlue.withValues(alpha: 0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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

// HUD cell — icon + value

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
          Icon(icon, size: 12, color: iconColor),
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
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 14,
      color: AppColors.divider,
    );
  }
}


// ────────────────────────────────────────────────────────────────
// Expanded body — ledger lines + explorer's notes
// ────────────────────────────────────────────────────────────────

class _ExpandedBody extends StatelessWidget {
  final StrategyItinerary day;

  const _ExpandedBody({required this.day});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider
        Container(
          height: 1,
          color: AppColors.divider,
          margin: const EdgeInsets.symmetric(horizontal: 14),
        ),
        const SizedBox(height: 14),

        // ── Checkpoint Ledger ──────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TREK DETAILS',
                style: GoogleFonts.dmSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              _LedgerLine(
                label: 'Altitude Gain',
                value: '+${day.altitudeGain}m',
                pillColor: AppColors.electricTeal,
              ),
              _LedgerLine(
                label: 'Altitude Loss',
                value: '-${day.altitudeLoss}m',
                pillColor: AppColors.coral,
              ),
              _LedgerLine(
                label: 'Temperature',
                value: '${day.temperature}°C',
                pillColor: AppColors.saffron,
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ── Explorer's Notes ──────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left accent border
                    Container(
                      width: 3,
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
              ),
              if (day.trekDetails.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  day.trekDetails,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: AppColors.textLight,
                    height: 1.55,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}


// ────────────────────────────────────────────────────────────────
// Ledger line — thin horizontal rule + label + pill
// ────────────────────────────────────────────────────────────────

class _LedgerLine extends StatelessWidget {
  final String label;
  final String value;
  final Color pillColor;

  const _LedgerLine({
    required this.label,
    required this.value,
    required this.pillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          // Label
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(width: 8),
          // Ledger line (dashed)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: CustomPaint(
                size: const Size(double.infinity, 1),
                painter: _DashedLinePainter(color: AppColors.divider),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Value pill
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: pillColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: pillColor.withValues(alpha: 0.25),
                width: 0.5,
              ),
            ),
            child: Text(
              value,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: pillColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

