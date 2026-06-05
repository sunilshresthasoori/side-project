import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../app/theme/app_theme.dart';
import '../../../domain/models/strategy_model.dart';

class StrategyHero extends StatelessWidget {
  final StrategyDetail strategy;

  const StrategyHero({super.key, required this.strategy});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.glacierBlue.withValues(alpha: 0.15),
          AppColors.deepGlacier.withValues(alpha: 0.08),
        ],
      ),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      border: Border.all(
        color: AppColors.electricTeal.withValues(alpha: 0.2),
        width: 1,
      ),
      boxShadow: AppShadows.soft,
    ),
    child: Stack(
      children: [
        // Background decoration
        Positioned(
          right: -40,
          top: -40,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.electricTeal.withValues(alpha: 0.1),
                  AppColors.electricTeal.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Strategy Name
                Text(
                  strategy.name,
                  style: GoogleFonts.syne(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),

                // Route Type + Details Row
                Row(
                  children: [
                    _DetailBadge(
                      icon: Icons.map_rounded,
                      label: strategy.routeType,
                      color: AppColors.saffron,
                    ),
                    const SizedBox(width: 10),
                    _DetailBadge(
                      icon: Icons.calendar_today_rounded,
                      label: '${strategy.totalDays} days',
                      color: AppColors.electricTeal,
                    ),
                    const SizedBox(width: 10),
                    _DetailBadge(
                      icon: Icons.straighten_rounded,
                      label: '${strategy.totalDistance}km',
                      color: AppColors.coral,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Key Metrics Grid
                Row(
                  children: [
                    Expanded(
                      child: _MetricColumn(
                        label: 'Highest Point',
                        value: '${strategy.highestPoint}m',
                        icon: Icons.terrain_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricColumn(
                        label: 'Max Altitude',
                        value: '${strategy.maxAltitude}m',
                        icon: Icons.trending_up_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _DetailBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricColumn({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.electricTeal),
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
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}




