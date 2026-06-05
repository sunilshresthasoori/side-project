import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../app/theme/app_theme.dart';
import '../../../domain/models/strategy_model.dart';

class StrategyAltitude extends StatelessWidget {
  final List<StrategyWaypoint> waypoints;

  const StrategyAltitude({super.key, required this.waypoints});

  @override
  Widget build(BuildContext context) {
    if (waypoints.isEmpty) return const SizedBox.shrink();

    final altitudes = waypoints.map((w) => w.altitude.toDouble()).toList();
    final maxAlt = altitudes.reduce((a, b) => a > b ? a : b);
    final minAlt = altitudes.reduce((a, b) => a < b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Altitude Journey',
          style: GoogleFonts.syne(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.divider, width: 1),
            boxShadow: AppShadows.card,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Chart area
              SizedBox(
                height: 180,
                child: CustomPaint(
                  painter: _AltitudeChartPainter(
                    altitudes: altitudes,
                    maxAlt: maxAlt,
                    minAlt: minAlt,
                  ),
                  size: Size.infinite,
                ),
              ),
              const SizedBox(height: 20),

              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _LegendItem(
                    label: 'Max',
                    value: '${maxAlt.toInt()}m',
                    color: AppColors.saffron,
                  ),
                  _LegendItem(
                    label: 'Min',
                    value: '${minAlt.toInt()}m',
                    color: AppColors.coral,
                  ),
                  _LegendItem(
                    label: 'Climb',
                    value: '${(maxAlt - minAlt).toInt()}m',
                    color: AppColors.electricTeal,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _LegendItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textSub,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.syne(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _AltitudeChartPainter extends CustomPainter {
  final List<double> altitudes;
  final double maxAlt;
  final double minAlt;

  _AltitudeChartPainter({
    required this.altitudes,
    required this.maxAlt,
    required this.minAlt,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (altitudes.isEmpty) return;

    // Grid background
    _drawGrid(canvas, size);

    // Altitude line
    _drawAltitudeLine(canvas, size);

    // Points
    _drawPoints(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.divider.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;

    const gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final y = size.height * i / gridLines;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  void _drawAltitudeLine(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.electricTeal
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    for (int i = 0; i < altitudes.length; i++) {
      final x = size.width * i / (altitudes.length - 1 == 0 ? 1 : altitudes.length - 1);
      final normalized = (altitudes[i] - minAlt) / (maxAlt - minAlt == 0 ? 1 : maxAlt - minAlt);
      final y = size.height * (1 - normalized);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Area under curve
    final areaPaint = Paint()
      ..color = AppColors.electricTeal.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, areaPaint);
  }

  void _drawPoints(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.electricTeal
      ..style = PaintingStyle.fill;

    for (int i = 0; i < altitudes.length; i++) {
      final x = size.width * i / (altitudes.length - 1 == 0 ? 1 : altitudes.length - 1);
      final normalized = (altitudes[i] - minAlt) / (maxAlt - minAlt == 0 ? 1 : maxAlt - minAlt);
      final y = size.height * (1 - normalized);

      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

