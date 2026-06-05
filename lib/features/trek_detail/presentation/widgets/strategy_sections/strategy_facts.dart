import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../app/theme/app_theme.dart';
import '../../../domain/models/strategy_model.dart';

class StrategyFacts extends StatelessWidget {
  final StrategyDetail strategy;

  const StrategyFacts({super.key, required this.strategy});

  @override
  Widget build(BuildContext context) {
    final facts = [
      _FactItem(
        icon: Icons.calendar_today_rounded,
        label: 'Total Days',
        value: '${strategy.totalDays}',
        color: AppColors.saffron,
      ),
      _FactItem(
        icon: Icons.straighten_rounded,
        label: 'Total Distance',
        value: '${strategy.totalDistance}km',
        color: AppColors.electricTeal,
      ),
      _FactItem(
        icon: Icons.terrain_rounded,
        label: 'Max Altitude',
        value: '${strategy.maxAltitude}m',
        color: AppColors.coral,
      ),
      _FactItem(
        icon: Icons.map_rounded,
        label: 'Route Type',
        value: strategy.routeType,
        color: AppColors.glacierBlue,
      ),
      _FactItem(
        icon: Icons.terrain_rounded,
        label: 'Difficulty',
        value: '${strategy.totalDays > 10 ? "Hard" : "Moderate"}',
        color: AppColors.deepGlacier,
      ),
      _FactItem(
        icon: Icons.spa_rounded,
        label: 'Acclimatization',
        value: '${strategy.acclimatizationDays} days',
        color: AppColors.slateGray,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expedition Facts',
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
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.4,
            ),
            itemCount: facts.length,
            itemBuilder: (_, i) => facts[i],
          ),
        ),
      ],
    );
  }
}

class _FactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _FactItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: color,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.textSub,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.syne(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

