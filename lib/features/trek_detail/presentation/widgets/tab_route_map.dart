import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' show max;
import '../../../../app/theme/app_theme.dart';
import '../../domain/models/trek_detail_model.dart';

class TabRouteMap extends StatelessWidget {
  final List<RoutePoint> routePoints;
  const TabRouteMap({super.key, required this.routePoints});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Section header 
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  AppColors.saffron.withValues(alpha: 0.15),
                  AppColors.glacierBlue.withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(
                color: AppColors.saffron.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.saffron.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.insights_rounded,
                      color: AppColors.saffron, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Route Intelligence",
                        style: GoogleFonts.syne(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        "TACTICAL WAYPOINT ANALYSIS",
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.saffron,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
           const SizedBox(height: 16),

          //  Map + Altitude silhouette card
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _StatCard(
                icon: Icons.place,
                value: "${routePoints.length}",
                label: "Waypoints",
              ),
              _StatCard(
                icon: Icons.landscape,
                value:
                "${routePoints.map((e) => e.altitudeM).reduce(max)}m",
                label: "Highest",
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              gradient: const LinearGradient(
                colors: [Color(0xFF0D1B2A), Color(0xFF1A3A5C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: AppShadows.soft,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Column(
                children: [
                  // Altitude silhouette
                  _AltitudeSilhouette(routePoints: routePoints),

                  // Divider
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),

                  // Map placeholder with waypoint chain
                  _MapPlaceholder(routePoints: routePoints),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          //  Waypoint list header 
          Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  size: 14, color: AppColors.coral),
              const SizedBox(width: 6),
              Text(
                'CONNECTED WAYPOINT CHAIN',
                style: GoogleFonts.dmSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                  letterSpacing: 1.4,
                ),
              ),
              const Spacer(),
              Text(
                '${routePoints.length} points',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  color: AppColors.textSub,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          //  Waypoint chain list 
          ...routePoints.asMap().entries.map((e) {
            final isLast = e.key == routePoints.length - 1;
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (e.key * 150)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, opacity, child) {
                return Opacity(
                  opacity: opacity,
                  child: Transform.translate(
                    offset: Offset(20 * (1 - opacity), 0),
                    child: child,
                  ),
                );
              },
              child: _WaypointRow(
                point: e.value,
                index: e.key,
                isLast: isLast,
                routePoints: routePoints,
              ),
            );
          }),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// 
// Altitude silhouette — filled area chart using CustomPaint
// 

class _AltitudeSilhouette extends StatelessWidget {
  final List<RoutePoint> routePoints;
  const _AltitudeSilhouette({required this.routePoints});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.show_chart_rounded,
                  size: 12, color: AppColors.saffron),
              const SizedBox(width: 6),
              Text(
                'UNIFIED ALTITUDE SILHOUETTE',
                style: GoogleFonts.dmSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.white60,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1500),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, progress, _) {
                return CustomPaint(
                  size: const Size(double.infinity, 80),
                  painter: _AnimatedSilhouettePainter(
                    points: routePoints,
                    progress: progress,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          // Point labels
          Row(
            children: routePoints.map((pt) => Expanded(
              child: Text(
                pt.name.split(' ').first,
                style: GoogleFonts.dmSans(
                  fontSize: 8,
                  color: Colors.white38,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )).toList(),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

class _AnimatedSilhouettePainter extends CustomPainter {
  final List<RoutePoint> points;
  final double progress;
  const _AnimatedSilhouettePainter({required this.points, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final maxAlt = points.map((p) => p.altitudeM).reduce((a, b) => a > b ? a : b).toDouble();
    final minAlt = points.map((p) => p.altitudeM).reduce((a, b) => a < b ? a : b).toDouble();
    final range = (maxAlt - minAlt).clamp(1, double.infinity);

    // Build path points
    final pts = <Offset>[];
    for (var i = 0; i < points.length; i++) {
      final x = i / (points.length - 1) * size.width;
      final normalized = (points[i].altitudeM - minAlt) / range;
      final y = size.height - (normalized * size.height * 0.85) - 6;
      pts.add(Offset(x, y));
    }

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));

    // Filled silhouette
    final fillPath = Path();
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      final cp1 = Offset(
        pts[i - 1].dx + (pts[i].dx - pts[i - 1].dx) / 3,
        pts[i - 1].dy,
      );
      final cp2 = Offset(
        pts[i].dx - (pts[i].dx - pts[i - 1].dx) / 3,
        pts[i].dy,
      );
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i].dx, pts[i].dy);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.saffron.withValues(alpha: 0.5),
          AppColors.coral.withValues(alpha: 0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // Stroke line
    final strokePath = Path();
    strokePath.moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      final cp1 = Offset(
        pts[i - 1].dx + (pts[i].dx - pts[i - 1].dx) / 3,
        pts[i - 1].dy,
      );
      final cp2 = Offset(
        pts[i].dx - (pts[i].dx - pts[i - 1].dx) / 3,
        pts[i].dy,
      );
      strokePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i].dx, pts[i].dy);
    }
    final strokePaint = Paint()
      ..color = AppColors.saffron
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(strokePath, strokePaint);

    // Dots at each point
    for (final pt in pts) {
      canvas.drawCircle(
        pt,
        3,
        Paint()..color = AppColors.saffron,
      );
      canvas.drawCircle(
        pt,
        2,
        Paint()..color = Colors.white,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_AnimatedSilhouettePainter old) => old.points != points || old.progress != progress;
}

// 
// Map placeholder with topo lines and waypoint dots
// 

class _MapPlaceholder extends StatelessWidget {
  final List<RoutePoint> routePoints;
  const _MapPlaceholder({required this.routePoints});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, progress, child) {
        return SizedBox(
          height: 180,
          child: Stack(
            children: [
              // Topo background
              CustomPaint(
                size: const Size(double.infinity, 180),
                painter: _TopoPainter(),
              ),

              // Center label
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2)),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              // Waypoint dots scattered across the map
              ..._buildWaypointDots(routePoints, progress),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildWaypointDots(List<RoutePoint> points, double progress) {
    if (points.isEmpty) return [];

    // Predefined scatter positions (left-to-right progression, slight y variation)
    const positions = [
      Offset(0.12, 0.65),
      Offset(0.28, 0.42),
      Offset(0.42, 0.55),
      Offset(0.55, 0.30),
      Offset(0.68, 0.48),
      Offset(0.80, 0.25),
      Offset(0.90, 0.38),
      Offset(0.95, 0.20),
    ];

    final widgets = <Widget>[];
    final count = points.length.clamp(0, positions.length);

    // Sequential progress for lines
    for (var i = 0; i < count - 1; i++) {
      final startProgress = i / (count - 1);
      final endProgress = (i + 1) / (count - 1);
      final lineProgress = ((progress - startProgress) / (endProgress - startProgress)).clamp(0.0, 1.0);

      widgets.add(
        Positioned.fill(
          child: CustomPaint(
            painter: _DotLinePainter(
              from: positions[i],
              to: positions[i + 1],
              progress: lineProgress,
            ),
          ),
        ),
      );
    }

    // Dots
    for (var i = 0; i < count; i++) {
      final pos = positions[i];
      final isLast = i == count - 1;
      final dotAppearProgress = i / (count - 1);
      
      if (progress >= dotAppearProgress) {
        widgets.add(
          Align(
            alignment: Alignment(pos.dx * 2 - 1, pos.dy * 2 - 1),
            child: _WaypointDot(
              label: '[${(i + 1).toString().padLeft(2, '0')}]',
              name: points[i].name.split(' ').first,
              isDestination: isLast,
            ),
          ),
        );
      }
    }

    return widgets;
  }
}

class _DotLinePainter extends CustomPainter {
  final Offset from; // fractional 0..1
  final Offset to;
  final double progress;

  const _DotLinePainter({required this.from, required this.to, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final p1 = Offset(from.dx * size.width, from.dy * size.height);
    final p2 = Offset(to.dx * size.width, to.dy * size.height);
    
    final current = Offset.lerp(p1, p2, progress)!;

    canvas.drawLine(
      p1,
      current,
      Paint()
        ..color = AppColors.glacierBlue.withValues(alpha: 0.5)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_DotLinePainter old) => old.progress != progress;
}

class _WaypointDot extends StatefulWidget {
  final String label;
  final String name;
  final bool isDestination;

  const _WaypointDot({
    required this.label,
    required this.name,
    required this.isDestination,
  });

  @override
  State<_WaypointDot> createState() => _WaypointDotState();
}

class _WaypointDotState extends State<_WaypointDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.isDestination) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.dmSans(
            fontSize: 8,
            color: Colors.white38,
          ),
        ),
        const SizedBox(height: 2),
        ScaleTransition(
          scale: widget.isDestination
              ? _animation
              : const AlwaysStoppedAnimation(1.0),
          child: Container(
            width: widget.isDestination ? 12 : 9,
            height: widget.isDestination ? 12 : 9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isDestination
                  ? AppColors.coral
                  : AppColors.glacierBlue,
              border: Border.all(color: Colors.white, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: (widget.isDestination
                          ? AppColors.coral
                          : AppColors.glacierBlue)
                      .withValues(alpha: 0.6),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          widget.name,
          style: GoogleFonts.dmSans(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

// 
// Waypoint chain list row
// 

class _WaypointRow extends StatefulWidget {
  final RoutePoint point;
  final int index;
  final bool isLast;
  final List<RoutePoint> routePoints;

  const _WaypointRow({
    required this.point,
    required this.index,
    required this.isLast,
    required this.routePoints,
  });

  @override
  State<_WaypointRow> createState() => _WaypointRowState();
}

class _WaypointRowState extends State<_WaypointRow> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDestination = widget.isLast;
    
    final previousAltitude = widget.index == 0
        ? widget.point.altitudeM
        : widget.routePoints[widget.index - 1].altitudeM;
    final diff = widget.point.altitudeM - previousAltitude;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //  Left: step number + connector line
          SizedBox(
            width: 36,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Line below node (not for last)
                if (!widget.isLast)
                  Positioned(
                    top: 24,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 1.5,
                        color: AppColors.glacierBlue.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                // Step circle
                Positioned(
                  top: 6,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: isDestination
                          ? AppGradients.saffronAccent
                          : const LinearGradient(
                        colors: [
                          AppColors.glacierBlue,
                          AppColors.deepGlacier,
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.glacierWhite,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isDestination
                              ? AppColors.saffron
                              : AppColors.glacierBlue)
                              .withValues(alpha: 0.35),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${widget.point.stepNumber}',
                        style: GoogleFonts.syne(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          //  Right: waypoint card
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => expanded = !expanded),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                transform: Matrix4.translationValues(
                  0.0,
                  expanded ? -4.0 : 0.0,
                  0.0,
                ),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDestination
                      ? AppColors.saffron.withValues(alpha: 0.06)
                      : AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isDestination
                        ? AppColors.saffron.withValues(alpha: 0.3)
                        : AppColors.divider,
                  ),
                  boxShadow: expanded ? AppShadows.soft : AppShadows.card,
                ),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.point.name,
                                  style: GoogleFonts.syne(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                // Ledger line
                                Row(
                                  children: [
                                    const Icon(Icons.filter_hdr_rounded,
                                        size: 10, color: AppColors.electricTeal),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${widget.point.altitudeM}m altitude',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 10,
                                        color: AppColors.textSub,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (widget.index > 0) ...[
                                      Icon(
                                        diff >= 0
                                            ? Icons.arrow_upward_rounded
                                            : Icons.arrow_downward_rounded,
                                        size: 10,
                                        color: diff >= 0 ? AppColors.electricTeal : AppColors.coral,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${diff.abs()}m',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: diff >= 0 ? AppColors.electricTeal : AppColors.coral,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Arrow
                          AnimatedRotation(
                            turns: expanded ? 0.25 : 0,
                            duration: const Duration(milliseconds: 250),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              size: 16,
                              color: isDestination
                                  ? AppColors.saffron
                                  : AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                      if (expanded)
                        Column(
                          children: [
                            const Divider(height: 20, color: AppColors.divider),
                            Row(
                              children: [
                                const Icon(Icons.info_outline_rounded,
                                    size: 12, color: AppColors.textLight),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    "Waypoint ${widget.point.stepNumber} in the connected chain. Strategic altitude: ${widget.point.altitudeM}m.",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 10,
                                      color: AppColors.textSub,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 
// Topographic background painter
// 

class _TopoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 1; i <= 8; i++) {
      final path = Path();
      final offset = i * 10.0;
      path.moveTo(0, size.height * 0.4 + offset);
      path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.15 + offset,
        size.width * 0.5, size.height * 0.3 + offset,
      );
      path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.45 + offset,
        size.width, size.height * 0.2 + offset,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 44) / 2,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.saffron.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: AppColors.saffron),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.syne(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    color: AppColors.textSub,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
