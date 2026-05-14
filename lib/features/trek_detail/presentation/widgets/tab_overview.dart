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

        const SizedBox(height: 12),

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
              // 2-column stat grid
              GridView.count(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
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

        const SizedBox(height: 12),

        // Quick Actions
        const _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(title: 'Quick Actions', icon: Icons.bolt_rounded),
              SizedBox(height: 14),
              _QuickAction(
                  icon: Icons.download_rounded,
                  label: 'Download Itinerary',
                  color: AppColors.glacierBlue),
              SizedBox(height: 10),
              _QuickAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Ask a Question',
                  color: AppColors.glacierBlue),
              SizedBox(height: 10),
              _QuickAction(
                  icon: Icons.map_outlined,
                  label: 'View on Map',
                  color: AppColors.glacierBlue),
              SizedBox(height: 10),
              _QuickAction(
                  icon: Icons.share_rounded,
                  label: 'Share This Trek',
                  color: AppColors.glacierBlue),
            ],
          ),
        ),

        const SizedBox(height: 12),

        //  Similar Treks teaser
        const _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(
                  title: 'Similar Treks', icon: Icons.explore_rounded),
              SizedBox(height: 14),
              _SimilarTrekRow(
                imagePath: 'assets/images/trek_annapurna.webp',
                title: 'Annapurna Circuit',
                duration: '15–20 days',
                difficulty: 'Hard',
                rating: 4.9,
              ),
              Divider(height: 20, color: AppColors.divider),
              _SimilarTrekRow(
                imagePath: 'assets/images/trek_langtang.webp',
                title: 'Langtang Valley Trek',
                duration: '7–10 days',
                difficulty: 'Moderate',
                rating: 4.7,
              ),
              Divider(height: 20, color: AppColors.divider),
              _SimilarTrekRow(
                imagePath: 'assets/images/trek_manaslu.png',
                title: 'Manaslu Circuit Trek',
                duration: '14–18 days',
                difficulty: 'Hard',
                rating: 4.8,
              ),
            ],
          ),
        ),

        const SizedBox(height: 100), // space for booking bar
      ],
    );
  }
}

//  SHARED COMPONENTS

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        child: child,
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

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickAction(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.07),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: color.withOpacity(0.18)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 12),
              Text(label,
                  style: GoogleFonts.dmSans(
                      fontSize: 13, fontWeight: FontWeight.w600, color: color)),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 11, color: color.withOpacity(0.6)),
            ],
          ),
        ),
      );
}

class _SimilarTrekRow extends StatelessWidget {
  final String imagePath;
  final String title;
  final String duration;
  final String difficulty;
  final double rating;

  const _SimilarTrekRow(
      {required this.imagePath,
      required this.title,
      required this.duration,
      required this.difficulty,
      required this.rating});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: TrekAssetImage(
                assetPath: imagePath, width: 64, height: 52, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.syne(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 11, color: AppColors.textLight),
                    const SizedBox(width: 3),
                    Text(duration,
                        style: AppTypography.caption(context)
                            .copyWith(fontSize: 11)),
                    const SizedBox(width: 8),
                    Text('• $difficulty',
                        style: AppTypography.caption(context)
                            .copyWith(fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 3),
                StarRow(rating: rating),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
        ],
      );
}
