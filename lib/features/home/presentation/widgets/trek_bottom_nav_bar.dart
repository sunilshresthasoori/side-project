
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';

class TrekBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const TrekBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.explore_rounded, label: 'Explore'),
    _NavItem(icon: Icons.add_circle_rounded, label: 'Post'),
    _NavItem(icon: Icons.people_alt_rounded, label: 'Community'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.slateGray.withOpacity(0.1),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _items.asMap().entries.map((e) {
              final idx = e.key;
              final item = e.value;
              final isSelected = idx == currentIndex;

              // Special center "Post" button
              if (idx == 2) {
                return GestureDetector(
                  onTap: () => onTap(idx),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppGradients.saffronAccent,
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.button,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                );
              }

              return GestureDetector(
                onTap: () => onTap(idx),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Dot indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        width: isSelected ? 24 : 0,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient:
                              isSelected ? AppGradients.saffronAccent : null,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        item.icon,
                        size: 22,
                        color: isSelected
                            ? AppColors.saffron
                            : AppColors.textLight,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: GoogleFonts.dmSans(
                          fontSize: 9,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.saffron
                              : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
