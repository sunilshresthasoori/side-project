import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../domain/models/trek_detail_model.dart';

class TabOverview extends StatefulWidget {
  final TrekDetail detail;

  const TabOverview({super.key, required this.detail});

  @override
  State<TabOverview> createState() => _TabOverviewState();
}

class _TabOverviewState extends State<TabOverview> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Floating Highlight Card
        Transform.translate(
          offset: const Offset(0, -24),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: AppColors.divider.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _HighlightItem(
                  icon: Icons.filter_hdr_rounded,
                  label: 'Highest Point',
                  value: '${widget.detail.maxAltitudeM}m',
                  color: AppColors.electricTeal,
                ),
                Container(height: 30, width: 1, color: AppColors.divider),
                _HighlightItem(
                  icon: Icons.wb_sunny_rounded,
                  label: 'Best Season',
                  value: widget.detail.bestSeason,
                  color: AppColors.saffron,
                ),
              ],
            ),
          ),
        ),

        // about this
        _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                  title: 'About This Trek', icon: Icons.info_outline_rounded),
              const SizedBox(height: 14),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: Text(
                  widget.detail.aboutText,
                  style: AppTypography.body(context),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                secondChild: Text(
                  widget.detail.aboutText,
                  style: AppTypography.body(context),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _expanded ? 'Show less' : 'Read more',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.electricTeal,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: AppColors.electricTeal,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Trek Statistics
        _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionTitle(
                      title: 'Trek Statistics', icon: Icons.bar_chart_rounded),
                  DifficultyBadge(level: widget.detail.difficulty),
                ],
              ),
              const SizedBox(height: 16),
              // 2-column stat grid
              GridView.count(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.8,
                children: [
                  _StatRow(
                      icon: Icons.access_time_rounded,
                      label: 'Duration',
                      value:
                          '${widget.detail.durationDays}–${widget.detail.durationDays + 2} days',
                      color: AppColors.glacierBlue),
                  _StatRow(
                      icon: Icons.filter_hdr_rounded,
                      label: 'Max Altitude',
                      value: '${widget.detail.maxAltitudeM}m',
                      color: AppColors.electricTeal),
                  _StatRow(
                      icon: Icons.straighten_rounded,
                      label: 'Distance',
                      value: '${widget.detail.distanceKm}km',
                      color: AppColors.coral),
                  _StatRow(
                      icon: Icons.wb_sunny_rounded,
                      label: 'Best Season',
                      value: widget.detail.bestSeason,
                      color: AppColors.saffron),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Why You'll Love This Trek
        _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                  title: "Why You'll Love This Trek",
                  icon: Icons.favorite_rounded),
              const SizedBox(height: 16),
              _HighlightBullet(
                  text: 'Sunrise from Poon Hill', color: AppColors.saffron),
              _HighlightBullet(
                  text: 'Tea house experience', color: AppColors.electricTeal),
              _HighlightBullet(
                  text: 'Himalayan panorama', color: AppColors.glacierBlue),
              _HighlightBullet(
                  text: 'Beginner friendly', color: AppColors.coral),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Quick Actions
        _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(title: 'Quick Actions', icon: Icons.bolt_rounded),
              const SizedBox(height: 16),
              _QuickAction(
                  icon: Icons.download_rounded,
                  label: 'Download Itinerary',
                  color: AppColors.glacierBlue),
              const SizedBox(height: 12),
              _QuickAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Ask a Question',
                  color: AppColors.glacierBlue),
              const SizedBox(height: 12),
              _QuickAction(
                  icon: Icons.map_outlined,
                  label: 'View on Map',
                  color: AppColors.glacierBlue),
              const SizedBox(height: 12),
              _QuickAction(
                  icon: Icons.share_rounded,
                  label: 'Share This Trek',
                  color: AppColors.glacierBlue),
            ],
          ),
        ),

        const SizedBox(height: 24),

        //  Similar Treks teaser
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const _SectionTitle(
              title: 'Similar Treks', icon: Icons.explore_rounded),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: const [
              _SimilarTrekCard(
                imagePath: 'assets/images/trek_annapurna.webp',
                title: 'Annapurna Circuit',
                duration: '15–20 days',
                difficulty: 'Hard',
                rating: 4.9,
              ),
              _SimilarTrekCard(
                imagePath: 'assets/images/trek_langtang.webp',
                title: 'Langtang Valley Trek',
                duration: '7–10 days',
                difficulty: 'Moderate',
                rating: 4.7,
              ),
              _SimilarTrekCard(
                imagePath: 'assets/images/trek_manaslu.png',
                title: 'Manaslu Circuit Trek',
                duration: '14–18 days',
                difficulty: 'Hard',
                rating: 4.8,
              ),
            ],
          ),
        ),

        const SizedBox(height: 120), // space for booking bar
      ],
    );
  }
}

class _HighlightItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _HighlightItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 10,
            color: AppColors.textSub,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.syne(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _HighlightBullet extends StatelessWidget {
  final String text;
  final Color color;

  const _HighlightBullet({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}


//  SHARED COMPONENTS

class _SectionCard extends StatefulWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: _isHovered ? AppShadows.soft : AppShadows.card,
            border: Border.all(
              color: _isHovered
                  ? AppColors.saffron.withOpacity(0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: widget.child,
        ),
      );
}


class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 16, color: AppColors.saffron),
          const SizedBox(width: 8),
          Text(title, style: AppTypography.headline(context)),
        ],
      );
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label,
                    style:
                        AppTypography.caption(context).copyWith(fontSize: 10)),
                Text(value,
                    style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      );
}

class _QuickAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        setState(() => _isPressed = true);
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) setState(() => _isPressed = false);
      },
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _isPressed
              ? widget.color.withOpacity(0.12)
              : widget.color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: _isPressed
                ? widget.color.withOpacity(0.4)
                : widget.color.withOpacity(0.18),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(widget.icon, size: 16, color: widget.color),
                const SizedBox(width: 12),
                Text(
                  widget.label,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.color,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11,
                  color: widget.color.withOpacity(0.6),
                ),
              ],
            ),
            if (_isPressed) ...[
              const SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1500),
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: widget.color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                    minHeight: 2,
                    borderRadius: BorderRadius.circular(2),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SimilarTrekCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String duration;
  final String difficulty;
  final double rating;

  const _SimilarTrekCard({
    required this.imagePath,
    required this.title,
    required this.duration,
    required this.difficulty,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.md),
            ),
            child: TrekAssetImage(
              assetPath: imagePath,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.syne(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      duration,
                      style: AppTypography.caption(context).copyWith(
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '• $difficulty',
                      style: AppTypography.caption(context).copyWith(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                StarRow(rating: rating),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

