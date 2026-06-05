import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../app/theme/app_theme.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../domain/models/strategy_model.dart';

class StrategyRoute extends StatelessWidget {
  final List<StrategyWaypoint> waypoints;

  const StrategyRoute({super.key, required this.waypoints});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Route Map Story',
          style: GoogleFonts.syne(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: waypoints.length,
            itemBuilder: (_, index) {
              final waypoint = waypoints[index];
              final isLast = index == waypoints.length - 1;

              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : 8,
                  right: isLast ? 0 : 8,
                ),
                child: _WaypointCard(
                  waypoint: waypoint,
                  isLast: isLast,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _WaypointCard extends StatelessWidget {
  final StrategyWaypoint waypoint;
  final bool isLast;

  const _WaypointCard({
    required this.waypoint,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        children: [
          // Image or placeholder
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.glacierBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: AppColors.divider,
                  width: 1,
                ),
              ),
              child: waypoint.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      child: TrekAssetImage(
                        assetPath: waypoint.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 36,
                          color: AppColors.deepGlacier.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 10),

          // Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order badge + name
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: AppGradients.saffronAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${waypoint.order}',
                        style: GoogleFonts.syne(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      waypoint.name,
                      style: GoogleFonts.syne(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Altitude
              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    size: 12,
                    color: AppColors.electricTeal,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${waypoint.altitude}m',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.electricTeal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Type
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.saffron.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  waypoint.type,
                  style: GoogleFonts.dmSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.saffron,
                  ),
                ),
              ),
            ],
          ),

          // Arrow down
          if (!isLast) ...[
            const SizedBox(height: 8),
            const Icon(
              Icons.arrow_downward_rounded,
              size: 16,
              color: AppColors.textLight,
            ),
          ],
        ],
      ),
    );
  }
}



