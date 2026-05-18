import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/profile_bloc.dart';
import '../../domain/model/profile_model.dart';
//  TAB BAR

class ProfileTabBar extends StatelessWidget {
  final ProfileTab activeTab;

  const ProfileTabBar({super.key, required this.activeTab});

  static const _tabs = [
    (ProfileTab.overview, 'Overview'),
    (ProfileTab.treks, 'Treks'),
    (ProfileTab.stories, 'Stories'),
    (ProfileTab.saved, 'Saved'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Row(
        children: _tabs.map((t) {
          final isActive = t.$1 == activeTab;
          return Expanded(
            child: GestureDetector(
              onTap: () =>
                  context.read<ProfileBloc>().add(ProfileTabChangedEvent(t.$1)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isActive ? AppColors.saffron : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    t.$2,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? AppColors.saffron : AppColors.textSub,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

//  TAB BODY SWITCHER

class ProfileTabBody extends StatelessWidget {
  final ProfileLoaded state;

  const ProfileTabBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state.activeTab) {
      ProfileTab.overview => _OverviewTab(profile: state.profile),
      ProfileTab.treks => _TreksTab(profile: state.profile),
      ProfileTab.stories => _StoriesTab(profile: state.profile),
      ProfileTab.saved => _SavedTab(savedIds: state.profile.savedTrekIds),
    };
  }
}

//  OVERVIEW TAB

class _OverviewTab extends StatelessWidget {
  final UserProfile profile;

  const _OverviewTab({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Trek heatmap teaser
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _MiniHeader(icon: '🗺', title: 'Trek Activity'),
                const SizedBox(height: 14),
                _HeatmapTeaser(),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Recent activity
          const _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MiniHeader(icon: '⚡', title: 'Recent Activity'),
                SizedBox(height: 14),
                _ActivityItem(
                    icon: '🏔',
                    text: 'Completed Everest Base Camp Trek',
                    time: '2 weeks ago',
                    color: AppColors.coral),
                Divider(height: 20, color: AppColors.divider),
                _ActivityItem(
                    icon: '✍️',
                    text: 'Published "Surviving a Snowstorm at Thorong La"',
                    time: '1 month ago',
                    color: AppColors.electricTeal),
                Divider(height: 20, color: AppColors.divider),
                _ActivityItem(
                    icon: '🔖',
                    text: 'Saved Kanchenjunga Base Camp to wishlist',
                    time: '1 month ago',
                    color: AppColors.glacierBlue),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Trek wishlist teaser
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const _MiniHeader(icon: '🛒', title: 'Trek Wishlist'),
                    const Spacer(),
                    Text('${profile.savedTrekIds.length} treks',
                        style: GoogleFonts.dmSans(
                            fontSize: 11, color: AppColors.textLight)),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'You have ${profile.savedTrekIds.length} treks saved for later.',
                  style: GoogleFonts.dmSans(
                      fontSize: 13, color: AppColors.textSub, height: 1.5),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => context
                      .read<ProfileBloc>()
                      .add(const ProfileTabChangedEvent(ProfileTab.saved)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View saved treks',
                          style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.electricTeal)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded,
                          size: 14, color: AppColors.electricTeal),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

//  TREKS TAB

class _TreksTab extends StatelessWidget {
  final UserProfile profile;

  const _TreksTab({required this.profile});

  // Mock completed treks list
  static const _completed = [
    _TrekSummary('Everest Base Camp', 'Khumbu', 14, 5364, 'Hard',
        'assets/images/trek_everest.jpg', 'Nov 2025'),
    _TrekSummary('Annapurna Circuit', 'Gandaki', 18, 5416, 'Hard',
        'assets/images/trek_annapurna.jpg', 'Apr 2025'),
    _TrekSummary('Langtang Valley', 'Rasuwa', 10, 4984, 'Easy',
        'assets/images/trek_langtang.jpg', 'Oct 2024'),
    _TrekSummary('Gokyo Lakes Trek', 'Khumbu', 12, 5357, 'Moderate',
        'assets/images/cat_glacier.jpg', 'May 2024'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ..._completed.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CompletedTrekCard(trek: t),
              )),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _TrekSummary {
  final String title, region, difficulty, imagePath, completedDate;
  final int days, altitudeM;

  const _TrekSummary(this.title, this.region, this.days, this.altitudeM,
      this.difficulty, this.imagePath, this.completedDate);
}

class _CompletedTrekCard extends StatelessWidget {
  final _TrekSummary trek;

  const _CompletedTrekCard({required this.trek});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.card),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 90,
                child: Stack(fit: StackFit.expand, children: [
                  TrekAssetImage(assetPath: trek.imagePath, fit: BoxFit.cover),
                  Container(
                      decoration: const BoxDecoration(
                          gradient: AppGradients.cardBottom)),
                  Positioned(
                      bottom: 6,
                      left: 6,
                      child: DifficultyBadge(level: trek.difficulty)),
                ]),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trek.title,
                          style: GoogleFonts.syne(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 3),
                      Row(children: [
                        const Icon(Icons.location_on_rounded,
                            size: 11, color: AppColors.coral),
                        const SizedBox(width: 2),
                        Text(trek.region,
                            style: GoogleFonts.dmSans(
                                fontSize: 11, color: AppColors.textSub)),
                      ]),
                      const SizedBox(height: 8),
                      Row(children: [
                        _MiniPill('${trek.days}d', AppColors.glacierBlue),
                        const SizedBox(width: 6),
                        _MiniPill(
                            '${(trek.altitudeM / 1000).toStringAsFixed(1)}km',
                            AppColors.electricTeal),
                        const Spacer(),
                        Text('✓ ${trek.completedDate}',
                            style: GoogleFonts.dmSans(
                                fontSize: 10,
                                color: AppColors.electricTeal,
                                fontWeight: FontWeight.w700)),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

//  STORIES TAB

class _StoriesTab extends StatelessWidget {
  final UserProfile profile;

  const _StoriesTab({required this.profile});

  static const _stories = [
    _StorySummary('Surviving a Snowstorm at Thorong La', 'Trek Report', 4821,
        213, '2h ago', 'assets/images/story_thorong.jpg'),
    _StorySummary('Mani Rimdu Festival', 'Culture', 7630, 389, '1d ago',
        'assets/images/story_mani_rimdu.jpg'),
    _StorySummary('Budget EBC: Under \$800 All-In', 'Tips', 5102, 447, '3d ago',
        'assets/images/story_budget.jpg'),
  ];

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            ..._stories.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _StoryCard(story: s),
                )),
            const SizedBox(height: 100),
          ],
        ),
      );
}

class _StorySummary {
  final String title, tag, timeAgo, imagePath;
  final int likes, comments;

  const _StorySummary(this.title, this.tag, this.likes, this.comments,
      this.timeAgo, this.imagePath);
}

class _StoryCard extends StatelessWidget {
  final _StorySummary story;

  const _StoryCard({required this.story});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppShadows.card),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(
              width: 90,
              height: 80,
              child:
                  TrekAssetImage(assetPath: story.imagePath, fit: BoxFit.cover),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TagBadge(label: story.tag, color: AppColors.deepGlacier),
                    const SizedBox(height: 5),
                    Text(story.title,
                        style: GoogleFonts.syne(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.favorite_rounded,
                          size: 12, color: AppColors.coral),
                      const SizedBox(width: 3),
                      Text(_fmt(story.likes),
                          style: GoogleFonts.dmSans(
                              fontSize: 10, color: AppColors.textSub)),
                      const SizedBox(width: 10),
                      const Icon(Icons.chat_bubble_outline_rounded,
                          size: 12, color: AppColors.textLight),
                      const SizedBox(width: 3),
                      Text('${story.comments}',
                          style: GoogleFonts.dmSans(
                              fontSize: 10, color: AppColors.textSub)),
                      const Spacer(),
                      Text(story.timeAgo,
                          style: GoogleFonts.dmSans(
                              fontSize: 10, color: AppColors.textLight)),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';
}

//  SAVED TAB

class _SavedTab extends StatelessWidget {
  final List<String> savedIds;

  const _SavedTab({required this.savedIds});

  static const _mock = [
    _TrekSummary('Gokyo Lakes Trek', 'Khumbu', 12, 5357, 'Moderate',
        'assets/images/cat_glacier.jpg', ''),
    _TrekSummary('Upper Mustang Trek', 'Mustang', 12, 3840, 'Moderate',
        'assets/images/trek_mustang.jpg', ''),
    _TrekSummary('Kanchenjunga BC', 'Taplejung', 22, 5143, 'Extreme',
        'assets/images/cat_high_altitude.jpg', ''),
  ];

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Icon(Icons.bookmark_rounded,
                      size: 14, color: AppColors.saffron),
                  const SizedBox(width: 6),
                  Text('${_mock.length} saved treks',
                      style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSub)),
                ],
              ),
            ),
            ..._mock.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CompletedTrekCard(trek: t),
                )),
            const SizedBox(height: 100),
          ],
        ),
      );
}

//  HEATMAP TEASER

class _HeatmapTeaser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    final activity = [0, 0, 2, 4, 5, 1, 0, 0, 3, 4, 5, 1];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(12, (i) {
        final level = activity[i];
        return Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: level == 0
                    ? AppColors.snowFog
                    : AppColors.electricTeal
                        .withOpacity(0.2 + (level / 5) * 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Text(months[i],
                style: GoogleFonts.dmSans(
                    fontSize: 8, color: AppColors.textLight)),
          ],
        );
      }),
    );
  }
}

//  SHARED HELPERS

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppShadows.card),
        child: child,
      );
}

class _MiniHeader extends StatelessWidget {
  final String icon, title;

  const _MiniHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text(title,
              style: GoogleFonts.syne(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
        ],
      );
}

class _ActivityItem extends StatelessWidget {
  final String icon, text, time;
  final Color color;

  const _ActivityItem(
      {required this.icon,
      required this.text,
      required this.time,
      required this.color});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm)),
              child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 14)))),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(text,
                    style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                        height: 1.4),
                    maxLines: 2),
                Text(time,
                    style: GoogleFonts.dmSans(
                        fontSize: 10, color: AppColors.textLight)),
              ])),
        ],
      );
}

class _MiniPill extends StatelessWidget {
  final String label;
  final Color color;

  const _MiniPill(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.full)),
        child: Text(label,
            style: GoogleFonts.dmSans(
                fontSize: 10, fontWeight: FontWeight.w600, color: color)),
      );
}
