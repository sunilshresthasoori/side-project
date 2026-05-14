import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';

class HeroSection extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onExploreTap;
  final VoidCallback? onCommunityTap;

  const HeroSection(
      {this.onCommunityTap,
      this.onExploreTap,
      this.onSearchChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      height: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          //fallback
          gradient: const LinearGradient(
              colors: [Color(0xFF0D1117), Color(0xFF2D6A9F)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft),
          boxShadow: AppShadows.soft),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Stack(
          fit: StackFit.expand,
          children: [
            TrekAssetImage(
              assetPath: 'assets/images/hero_bg.png',
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            Container(
              decoration:
                  const BoxDecoration(gradient: AppGradients.heroOverlay),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppColors.inkDark.withAlpha(50),
                  CupertinoColors.transparent
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
            ),
            //Main Content

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.saffron.withAlpha(20),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                        color: AppColors.saffron.withAlpha(50),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                              color: AppColors.saffron, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Headline
                  Text(
                    '',
                    style: GoogleFonts.dmSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: CupertinoColors.white,
                      height: 1.6,
                    ),
                  ),

                  const Spacer(),

                  //Search Bar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      boxShadow: const [
                        BoxShadow(
                          color: CupertinoColors.black,
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: onSearchChanged,
                      style: GoogleFonts.dmSans(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: "Search treks, region, difficulty...",
                        filled: true,
                        fillColor: CupertinoColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.glacierBlue,
                        ),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: AppGradients.saffronAccent,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: CupertinoColors.white,
                            size: 18,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 16),

                  //CTA buttons
                  /*Row(
                    children: [
                      Expanded(
                        child: _CtaButton(
                          label: 'Explore treks',
                          icon: Icons.explore_rounded,
                          gradient: AppGradients.saffronAccent,
                          onTap: onExploreTap ?? () {},
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: _CtaButton(
                            label: 'Community',
                            icon: Icons.people_alt_rounded,
                            gradient: AppGradients.tealAccent,
                            onTap: onCommunityTap ?? () {}),
                      ),
                    ],
                  )*/
                ],
              ),
            ),
            const Positioned(
                top: 32,
                left: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _StatChip(value: '240+', label: 'Treks'),
                    SizedBox(height: 8),
                    _StatChip(value: '18K', label: 'Trekkers'),
                    SizedBox(height: 8),
                    _StatChip(value: '4.9★', label: 'Rated'),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _CtaButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppRadius.full),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.syne(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;

  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(90),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: Colors.white.withAlpha(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            value,
            style: GoogleFonts.fredoka(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.saffron,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
