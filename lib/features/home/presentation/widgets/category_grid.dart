import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../domain/models/trek_models.dart';

class CategoryGrid extends StatelessWidget {
  final List<TrekCategory> categories;
  final ValueChanged<TrekCategory>? onCategoryTap;

  const CategoryGrid({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.05,
        ),
        itemBuilder: (context, index) => _CategoryCard(
          category: categories[index],
          onTap: () => onCategoryTap?.call(categories[index]),
        ),
      ),
    );
  }
}

// SINGLE CATEGORY CARD

class _CategoryCard extends StatelessWidget {
  final TrekCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  // Each category gets a distinct accent color for its overlay tint
  Color get _accentTint {
    switch (category.id) {
      case 'high-altitude': return const Color(0x442D6A9F);
      case 'forest-trails': return const Color(0x441A6B3A);
      case 'glacier-walks': return const Color(0x4400D4C8);
      case 'cultural-routes': return const Color(0x44FF9F0A);
      default: return const Color(0x991A202C);
    }
  }

  // Distinct icon per category
  IconData get _icon {
    switch (category.id) {
      case 'high-altitude':   return Icons.filter_hdr_rounded;
      case 'forest-trails':   return Icons.forest_rounded;
      case 'glacier-walks':   return Icons.ac_unit_rounded;
      case 'cultural-routes': return Icons.temple_buddhist_rounded;
      default:                return Icons.terrain;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              TrekAssetImage(
                assetPath: category.imagePath,
                fit: BoxFit.cover,
              ),

              // Bottom gradient overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: AppGradients.cardBottom,
                ),
              ),

              // Accent color tint
              Container(color: _accentTint),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon badge (top-left)
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(2),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(
                          color: Colors.white.withAlpha(25),
                        ),
                      ),
                      child: Icon(_icon, color: Colors.white, size: 20),
                    ),

                    // Title and subtitle (bottom)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.subtitle.toUpperCase(),
                          style: GoogleFonts.dmSans(
                            fontSize: 10, fontWeight: FontWeight.w700,
                            color: Colors.white.withAlpha(65),
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          category.title,
                          style: GoogleFonts.syne(
                            fontSize: 14, fontWeight: FontWeight.w800,
                            color: Colors.white, height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tap arrow indicator (bottom-right)
              Positioned(
                bottom: 14, right: 14,
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(30)),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//SKELETON LOADING (2×2)

class CategoryGridSkeleton extends StatelessWidget {
  const CategoryGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.05,
        children: List.generate(
          4,
              (_) => ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: const ShimmerBox(width: double.infinity, height: double.infinity, radius: 16),
          ),
        ),
      ),
    );
  }
}