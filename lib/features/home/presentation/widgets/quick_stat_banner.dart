import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';

class QuickStatsBanner extends StatelessWidget {
  const QuickStatsBanner({super.key});

  static const _stats = [
    _Stat(
        icon: Icons.terrain,
        value: '240+',
        label: 'Verified Treks',
        color: AppColors.deepGlacier),
    _Stat(
        icon: Icons.people_alt_rounded,
        value: '18K+',
        label: 'Active Trekkers',
        color: AppColors.saffron),
    _Stat(
        icon: Icons.emoji_events_rounded,
        value: '8',
        label: 'Countries',
        color: AppColors.coral),
    _Stat(
        icon: Icons.star_rounded,
        value: '4.9',
        label: 'Avg Rating',
        color: AppColors.electricTeal),
    _Stat(
        icon: Icons.photo_camera_rounded,
        value: '50K+',
        label: 'Trail Photos',
        color: AppColors.glacierBlue),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _StatBubble(stat: _stats[i]),
      ),
    );
  }
}

class _Stat {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
}

class _StatBubble extends StatelessWidget {
  final _Stat stat;

  const _StatBubble({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: stat.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: stat.color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(stat.icon, color: stat.color, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat.value,
                style: GoogleFonts.fredoka(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: stat.color,
                ),
              ),
              Text(
                stat.label,
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  color: AppColors.textSub,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
