
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/profile_bloc.dart';
import '../../data/repository/profile_mock_repository.dart';
import '../../domain/model/profile_model.dart';


class ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  final bool        isEditing;

  const ProfileHeader({super.key, required this.profile, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //  Cover + avatar stack 
        _CoverAvatarStack(profile: profile, isEditing: isEditing),

        //  Name / username / location 
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Name block
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.displayName,
                          style: GoogleFonts.syne(
                            fontSize: 24, fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary, height: 1.1,
                          ),
                        ),
                        if (profile.username != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            profile.displayUsername,
                            style: GoogleFonts.dmSans(
                              fontSize: 13, color: AppColors.glacierBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Edit / Save button
                  _EditButton(isEditing: isEditing),
                ],
              ),

              const SizedBox(height: 12),

              // Location pill
              if (profile.location != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.snowFog,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on_rounded, size: 13, color: AppColors.coral),
                        const SizedBox(width: 5),
                        Text(
                          profile.location!,
                          style: GoogleFonts.dmSans(
                            fontSize: 12, fontWeight: FontWeight.w600,
                            color: AppColors.textSub,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (profile.bio != null) ...[
                const SizedBox(height: 12),
                Text(
                  profile.bio!,
                  style: GoogleFonts.dmSans(
                    fontSize: 13, color: AppColors.textSub, height: 1.6,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              //  Stats row 
              _StatsRow(profile: profile),

              const SizedBox(height: 20),

              //  Altitude progress bar 
              _AltitudeBar(totalM: profile.totalAltitudeM),

              const SizedBox(height: 20),

              //  Badges row 
              _BadgesRow(badges: ProfileMockRepository.allBadges),
            ],
          ),
        ),
      ],
    );
  }
}

//  COVER + AVATAR STACK 

class _CoverAvatarStack extends StatelessWidget {
  final UserProfile profile;
  final bool        isEditing;

  const _CoverAvatarStack({required this.profile, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover image
          SizedBox(
            height: 185,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                profile.coverImage != null
                    ? TrekAssetImage(
                  assetPath: profile.coverImage!,
                  fit: BoxFit.cover,
                )
                    : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0D1117), Color(0xFF2D6A9F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Gradient bottom fade
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.glacierWhite.withOpacity(0.6),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
                // Edit cover button
                if (isEditing)
                  Positioned(
                    bottom: 12, right: 12,
                    child: _ImageEditBtn(
                      label: 'Change Cover',
                      onTap: () => context.read<ProfileBloc>().add(
                        const ProfileImageChangedEvent(
                          isCover: true,
                          path: 'assets/images/hero_bg.jpg',
                        ),
                      ),
                    ),
                  ),
                // Back button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                ),
                // Settings
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating avatar
          Positioned(
            bottom: 0, left: 20,
            child: Stack(
              children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.glacierWhite, width: 4),
                    boxShadow: AppShadows.soft,
                  ),
                  child: ClipOval(
                    child: profile.avatar != null
                        ? TrekAssetImage(assetPath: profile.avatar!, fit: BoxFit.cover, width: 90, height: 90)
                        : Container(
                      decoration: const BoxDecoration(
                        gradient: AppGradients.saffronAccent,
                      ),
                      child: Center(
                        child: Text(
                          profile.displayName.isNotEmpty
                              ? profile.displayName[0].toUpperCase()
                              : 'T',
                          style: GoogleFonts.syne(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                // Edit avatar button
                if (isEditing)
                  Positioned(
                    bottom: 0, right: 0,
                    child: GestureDetector(
                      onTap: () => context.read<ProfileBloc>().add(
                        const ProfileImageChangedEvent(isCover: false, path: 'assets/images/avatar_priya.jpg'),
                      ),
                      child: Container(
                        width: 26, height: 26,
                        decoration: BoxDecoration(
                          gradient: AppGradients.saffronAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, size: 13, color: Colors.white),
                      ),
                    ),
                  ),
                // Online / active indicator
                if (!isEditing)
                  Positioned(
                    bottom: 4, right: 4,
                    child: Container(
                      width: 16, height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2ECC71),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Profile completeness pill (top-right of avatar row)
          if (!isEditing && !profile.isComplete)
            Positioned(
              bottom: 28, right: 20,
              child: GestureDetector(
                onTap: () => context.read<ProfileBloc>().add(const ProfileEditStartedEvent()),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.saffron.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: AppColors.saffron.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 12, color: AppColors.saffron),
                      const SizedBox(width: 4),
                      Text('Complete profile', style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.saffron)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

//  EDIT BUTTON 

class _EditButton extends StatelessWidget {
  final bool isEditing;
  const _EditButton({required this.isEditing});

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return Row(
        children: [
          GestureDetector(
            onTap: () => context.read<ProfileBloc>().add(const ProfileEditCancelledEvent()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text('Cancel', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSub)),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.read<ProfileBloc>().add(const ProfileSaveEvent()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppGradients.saffronAccent,
                borderRadius: BorderRadius.circular(AppRadius.full),
                boxShadow: AppShadows.button,
              ),
              child: Text('Save', style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: () => context.read<ProfileBloc>().add(const ProfileEditStartedEvent()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: AppColors.divider),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.edit_rounded, size: 14, color: AppColors.slateGray),
            const SizedBox(width: 6),
            Text('Edit Profile', style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slateGray)),
          ],
        ),
      ),
    );
  }
}

//  STATS ROW 

class _StatsRow extends StatelessWidget {
  final UserProfile profile;
  const _StatsRow({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          _StatItem(value: '${profile.treksCompleted}',  label: 'Treks',      color: AppColors.glacierBlue),
          _Divider(),
          _StatItem(value: '${profile.storiesWritten}',  label: 'Stories',    color: AppColors.electricTeal),
          _Divider(),
          _StatItem(value: _fmt(profile.followersCount), label: 'Followers',  color: AppColors.saffron),
          _Divider(),
          _StatItem(value: _fmt(profile.followingCount), label: 'Following',  color: AppColors.coral),
        ],
      ),
    );
  }

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color  color;
  const _StatItem({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(value, style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 32, color: AppColors.divider);
}

//  ALTITUDE PROGRESS BAR 
// Shows lifetime altitude gained vs a fun milestone

class _AltitudeBar extends StatelessWidget {
  final int totalM;
  const _AltitudeBar({required this.totalM});

  @override
  Widget build(BuildContext context) {
    const milestone = 50000; // 50km altitude milestone
    final progress  = (totalM / milestone).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🏔', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text('Lifetime Altitude Gained', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                ],
              ),
              Text(
                '${(totalM / 1000).toStringAsFixed(1)}km / 50km',
                style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.electricTeal),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(height: 8, decoration: BoxDecoration(color: AppColors.snowFog, borderRadius: BorderRadius.circular(4))),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: AppGradients.tealAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(progress * 100).toStringAsFixed(0)}% to Everest height milestone',
              style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.textLight),
            ),
          ),
        ],
      ),
    );
  }
}

//  BADGES ROW 

class _BadgesRow extends StatelessWidget {
  final List<ProfileBadge> badges;
  const _BadgesRow({required this.badges});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('🎖️', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            Text('Badges', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const Spacer(),
            Text('${badges.where((b) => b.isEarned).length}/${badges.length} earned',
                style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textLight)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: badges.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => _BadgeChip(badge: badges[i]),
          ),
        ),
      ],
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final ProfileBadge badge;
  const _BadgeChip({required this.badge});

  @override
  Widget build(BuildContext context) => Tooltip(
    message: badge.description,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: badge.isEarned ? AppColors.saffron.withOpacity(0.1) : AppColors.snowFog,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: badge.isEarned ? AppColors.saffron.withOpacity(0.4) : AppColors.divider,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(badge.emoji, style: TextStyle(fontSize: 16, color: badge.isEarned ? null : const Color(0x88000000))),
          const SizedBox(width: 6),
          Text(
            badge.label,
            style: GoogleFonts.dmSans(
              fontSize: 11, fontWeight: FontWeight.w700,
              color: badge.isEarned ? AppColors.saffron : AppColors.textLight,
            ),
          ),
        ],
      ),
    ),
  );
}

//  IMAGE EDIT BUTTON 

class _ImageEditBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ImageEditBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.camera_alt_rounded, size: 12, color: Colors.white),
          const SizedBox(width: 5),
          Text(label, style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
        ],
      ),
    ),
  );
}