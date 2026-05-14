import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../domain/models/trek_detail_model.dart';

class TabRouteMap extends StatelessWidget {
  final List<RoutePoint> routePoints;
  const TabRouteMap({super.key, required this.routePoints});

  @override
  Widget build(BuildContext context) {
    final maxAlt = routePoints.map((r) => r.altitudeM).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // ── Map placeholder ──
          Container(
            width: double.infinity,
            height: 220,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              gradient: const LinearGradient(
                colors: [Color(0xFF1A3A5C), Color(0xFF2D6A9F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: AppShadows.card,
            ),
            child: Stack(
              children: [
                // Topographic pattern
                CustomPaint(
                  size: const Size(double.infinity, 220),
                  painter: _TopoPainter(),
                ),
                // Center label
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.map_outlined, color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Interactive map',
                        style: GoogleFonts.syne(
                          fontSize: 14, fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      /*Text(
                        'Add google_maps_flutter to enable',
                        style: GoogleFonts.dmSans(
                          fontSize: 11, color: Colors.white70,
                        ),
                      ),*/
                    ],
                  ),
                ),
                // Red pin
                Positioned(
                  top: 70, left: 160,
                  child: Container(
                    width: 16, height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.coral,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [BoxShadow(color: AppColors.coral.withOpacity(0.5), blurRadius: 8)],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Altitude Profile
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Altitude Profile',
                  style: GoogleFonts.syne(
                    fontSize: 14, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 70,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: routePoints.map((pt) {
                      final height = (pt.altitudeM / maxAlt) * 60;
                      final isLast = pt.stepNumber == routePoints.length;
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: height,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isLast
                                      ? [AppColors.saffron, AppColors.coral]
                                      : [AppColors.glacierBlue.withOpacity(0.6), AppColors.deepGlacier],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: routePoints.map((pt) => Expanded(
                    child: Text(
                      pt.name.split(' ').first,
                      style: GoogleFonts.dmSans(fontSize: 8, color: AppColors.textLight),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Route Points Grid
          Text(
            'Route Points',
            style: GoogleFonts.syne(
              fontSize: 16, fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: routePoints.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
            ),
            itemBuilder: (_, i) => _RoutePointCard(point: routePoints[i]),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _RoutePointCard extends StatelessWidget {
  final RoutePoint point;
  const _RoutePointCard({required this.point});

  @override
  Widget build(BuildContext context) {
    final isDestination = point.stepNumber == 8;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDestination
            ? AppColors.saffron.withOpacity(0.08)
            : AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDestination ? AppColors.saffron.withOpacity(0.3) : AppColors.divider,
        ),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              gradient: isDestination
                  ? AppGradients.saffronAccent
                  : const LinearGradient(colors: [AppColors.glacierBlue, AppColors.deepGlacier]),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${point.stepNumber}',
                style: GoogleFonts.syne(
                  fontSize: 11, fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  point.name,
                  style: GoogleFonts.syne(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${point.altitudeM}m altitude',
                  style: GoogleFonts.dmSans(
                    fontSize: 10, color: AppColors.textSub,
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

//  TOPOGRAPHIC CUSTOM PAINTER

class _TopoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 6; i++) {
      final path = Path();
      final offset = i * 12.0;
      path.moveTo(0, size.height * 0.3 + offset);
      path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.1 + offset,
        size.width * 0.5, size.height * 0.25 + offset,
      );
      path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.4 + offset,
        size.width, size.height * 0.2 + offset,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}