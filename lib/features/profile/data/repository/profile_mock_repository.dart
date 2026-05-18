import 'dart:async';

import '../../domain/model/profile_model.dart';

class ProfileMockRepository {
  Future<UserProfile> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const UserProfile(
      fullName: 'Sunita Thapa',
      username: 'sunita.treks',
      email: 'sunita@trekkers.com',
      avatar: 'assets/images/avatar_priya.jpg',
      coverImage: 'assets/images/hero_bg.jpg',
      bio:
          'High-altitude obsessed 🏔 EBC ✓ Annapurna ✓ Manaslu → next. Collecting summits, one teahouse at a time.',
      location: 'Kathmandu, Nepal',
      treksCompleted: 7,
      storiesWritten: 12,
      followersCount: 2840,
      followingCount: 318,
      totalAltitudeM: 34210,
      savedTrekIds: ['gokyo-lakes', 'upper-mustang', 'kanchenjunga'],
      badges: [
        'Summit Seeker',
        'Trail Blazer',
        'Story Teller',
        'Glacier Walker'
      ],
    );
  }

  Future<UserProfile> saveProfile({
    required UserProfile profile,
    String? newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // In real impl: PATCH /api/users/me with profile + optional password
    return profile;
  }

  static List<ProfileBadge> get allBadges => const [
        ProfileBadge(
            id: 'summit-seeker',
            label: 'Summit Seeker',
            emoji: '🏔',
            description: 'Completed 5+ high-altitude treks',
            isEarned: true),
        ProfileBadge(
            id: 'trail-blazer',
            label: 'Trail Blazer',
            emoji: '🔥',
            description: 'First to review 3 off-beat routes',
            isEarned: true),
        ProfileBadge(
            id: 'story-teller',
            label: 'Story Teller',
            emoji: '✍️',
            description: 'Published 10+ community stories',
            isEarned: true),
        ProfileBadge(
            id: 'glacier-walker',
            label: 'Glacier Walker',
            emoji: '❄️',
            description: 'Completed 3+ glacier treks',
            isEarned: true),
        ProfileBadge(
            id: 'culture-keeper',
            label: 'Culture Keeper',
            emoji: '🏛',
            description: 'Completed 5 cultural route treks',
            isEarned: false),
        ProfileBadge(
            id: 'expedition-pro',
            label: 'Expedition Pro',
            emoji: '⛺',
            description: 'Logged 100+ trekking days total',
            isEarned: false),
      ];
}
