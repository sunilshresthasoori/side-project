

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../app/theme/app_theme.dart';
import '../../../domain/models/strategy_model.dart';

class StrategySnapshot extends StatelessWidget {
  final StrategyDetail strategy;

  const StrategySnapshot({super.key, required this.strategy});

  @override
  Widget build(BuildContext context) {
    final items = [
      _SnapshotItem(
        icon: Icons.terrain_rounded,
        label: 'Highest Point',
        value: '${strategy.highestPoint}m',
        color: AppColors.saffron,
      ),
      _SnapshotItem(
        icon: Icons.arrow_downward_rounded,
        label: 'Lowest Point',
        value: '${strategy.maxAltitude - 2000}m',
        color: AppColors.coral,
      ),
      _SnapshotItem(
        icon: Icons.location_on_rounded,
        label: 'Start Point',
        value: strategy.accessCity,
        color: AppColors.electricTeal,
      ),
      _SnapshotItem(
        icon: Icons.flag_rounded,
        label: 'End Point',
        value: strategy.name.split(' ').last,
        color: AppColors.glacierBlue,
      ),
      _SnapshotItem(
        icon: Icons.location_city_rounded,
        label: 'Access City',
        value: strategy.accessCity,
        color: AppColors.deepGlacier,
      ),
      _SnapshotItem(
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
          'Trek Snapshot',
          style: GoogleFonts.syne(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) => items[i],
        ),
      ],
    );
  }
}

class _SnapshotItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SnapshotItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
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
              color: AppColors.textPrimary,
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

