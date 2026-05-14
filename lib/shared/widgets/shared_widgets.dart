import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/app_theme.dart';

class TrekAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;

  const TrekAppBar({super.key, this.onMenuTap, this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    gradient: AppGradients.saffronAccent,
                    borderRadius: BorderRadius.circular(AppRadius.sm)),
                child: const Icon(
                  Icons.terrain_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Trekkers",
                    style: GoogleFonts.syne(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.charcoal,
                        letterSpacing: 2),
                  ),
                  Text(
                    "Odyssey",
                    style: GoogleFonts.syne(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppColors.saffron,
                        letterSpacing: 3),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _IconBtn(
                icon: Icons.notifications_outlined,
                badge: true,
                onTap: onNotificationTap ?? () {},
              ),
              const SizedBox(
                width: 8,
              ),
              _IconBtn(
                icon: Icons.person_outline_rounded,
                badge: true,
                onTap: onMenuTap ?? () {},
              ),
            ],
          )
        ],
      ),
    ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final bool badge;
  final VoidCallback? onTap;

  const _IconBtn({required this.icon, this.badge = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              boxShadow: AppShadows.card,
            ),
            child: Icon(
              icon,
              color: AppColors.slateGray,
              size: 20,
            ),
          ),
          if (badge)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: AppColors.coral, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;

  const SectionHeader(
      {super.key,
      required this.title,
      this.actionLabel,
      this.onAction,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //left side title
          Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                    gradient: AppGradients.saffronAccent,
                    borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                title,
                style: AppTypography.headline(context),
              ),
            ],
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: AppColors.electricTeal.withAlpha(10),
                    borderRadius: BorderRadius.circular(AppRadius.full)),
                child: Text(
                  actionLabel!,
                  style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.electricTeal),
                ),
              ),
            ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

//tag badge
class TagBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const TagBadge(
      {super.key,
      required this.label,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: 0.3),
      ),
    );
  }
}

//difficulty badge
class DifficultyBadge extends StatelessWidget {
  final String level;

  const DifficultyBadge({super.key, required this.level});

  Color get _color {
    switch (level) {
      case 'Easy':
        return const Color(0xFF2ECC71);
      case 'Moderate':
        return AppColors.saffron;
      case 'Hard':
        return AppColors.coral;
      case 'Extreme':
        return const Color(0xFF9B59B6);
      default:
        return AppColors.glacierBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withAlpha(10),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: _color.withAlpha(40)),
      ),
      child: Text(
        level,
        style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: _color,
            letterSpacing: 0.4),
      ),
    );
  }
}

//star-row for rating

class StarRow extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final Color? starColor;
  final Color? textColor;

  const StarRow(
      {super.key,
      required this.rating,
      this.reviewCount,
      this.starColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    final count = reviewCount ?? 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          color: starColor,
          size: 14,
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          rating.toStringAsFixed(1),
          style: GoogleFonts.dmSans(
              fontSize: 12, fontWeight: FontWeight.w700, color: starColor),
        ),
        if (count > 0) ...[
          const SizedBox(
            width: 4,
          ),
          Text(
            '($count',
            style: GoogleFonts.dmSans(fontSize: 11, color: textColor),
          ),
        ]
      ],
    );
  }
}

// When asset is missing shows a pleasant gradient placeholder.

class TrekAssetImage extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const TrekAssetImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => _placeholder(),
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  Widget _placeholder() {
    // Rotate through a set of beautiful gradient placeholders
    final gradients = [
      [const Color(0xFF2D6A9F), const Color(0xFF5B9BD5)],
      [const Color(0xFF1A202C), const Color(0xFF2D6A9F)],
      [const Color(0xFF4A5568), const Color(0xFF2D6A9F)],
      [const Color(0xFF0D1117), const Color(0xFF4A5568)],
    ];
    final idx = assetPath.hashCode.abs() % gradients.length;
    final g = gradients[idx];

    Widget child = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          colors: g,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(Icons.terrain, color: Colors.white.withAlpha(40), size: 40),
      ),
    );
    return child;
  }
}

//loading skeleton

class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox(
      {super.key, required this.width, required this.height, this.radius = 12});

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 0.9)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Opacity(
              opacity: _anim.value,
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                    color: AppColors.iceBlue,
                    borderRadius: BorderRadius.circular(widget.radius)),
              ),
            ));
  }
}
