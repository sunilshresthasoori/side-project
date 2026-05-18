import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String? fullName;
  final String? username;
  final String? email;
  final String? avatar;
  final String? coverImage;
  final String? bio;
  final String? location;

  // password never stored in state — only passed during save

  // Stats (populated from backend later)
  final int treksCompleted;
  final int storiesWritten;
  final int followersCount;
  final int followingCount;
  final int totalAltitudeM;
  final List<String> savedTrekIds;
  final List<String> badges;

  const UserProfile({
    this.fullName,
    this.username,
    this.email,
    this.avatar,
    this.coverImage,
    this.bio,
    this.location,
    this.treksCompleted = 0,
    this.storiesWritten = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.totalAltitudeM = 0,
    this.savedTrekIds = const [],
    this.badges = const [],
  });

  String get displayName => fullName ?? username ?? 'Trekker';

  String get displayUsername => username != null ? '@$username' : '';

  bool get isComplete =>
      fullName != null && username != null && bio != null && location != null;

  UserProfile copyWith({
    String? fullName,
    String? username,
    String? email,
    String? avatar,
    String? coverImage,
    String? bio,
    String? location,
    int? treksCompleted,
    int? storiesWritten,
    int? followersCount,
    int? followingCount,
    int? totalAltitudeM,
    List<String>? savedTrekIds,
    List<String>? badges,
  }) =>
      UserProfile(
        fullName: fullName ?? this.fullName,
        username: username ?? this.username,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
        coverImage: coverImage ?? this.coverImage,
        bio: bio ?? this.bio,
        location: location ?? this.location,
        treksCompleted: treksCompleted ?? this.treksCompleted,
        storiesWritten: storiesWritten ?? this.storiesWritten,
        followersCount: followersCount ?? this.followersCount,
        followingCount: followingCount ?? this.followingCount,
        totalAltitudeM: totalAltitudeM ?? this.totalAltitudeM,
        savedTrekIds: savedTrekIds ?? this.savedTrekIds,
        badges: badges ?? this.badges,
      );

  @override
  List<Object?> get props => [
        fullName,
        username,
        email,
        avatar,
        coverImage,
        bio,
        location,
        treksCompleted,
        storiesWritten,
        followersCount,
        followingCount,
        totalAltitudeM,
        savedTrekIds,
        badges,
      ];
}

//  BADGE MODEL

class ProfileBadge extends Equatable {
  final String id;
  final String label;
  final String emoji;
  final String description;
  final bool isEarned;

  const ProfileBadge({
    required this.id,
    required this.label,
    required this.emoji,
    required this.description,
    this.isEarned = false,
  });

  @override
  List<Object?> get props => [id, isEarned];
}

//  PROFILE TAB

enum ProfileTab { overview, treks, stories, saved }
