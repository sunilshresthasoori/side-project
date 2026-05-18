

part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

// Load profile from repository
class ProfileFetchEvent extends ProfileEvent {
  const ProfileFetchEvent();
}

// User tapped "Edit Profile" button — enter edit mode
class ProfileEditStartedEvent extends ProfileEvent {
  const ProfileEditStartedEvent();
}

// User tapped "Cancel" in edit mode
class ProfileEditCancelledEvent extends ProfileEvent {
  const ProfileEditCancelledEvent();
}

// A field changed in the edit form
class ProfileFieldChangedEvent extends ProfileEvent {
  final String field; // 'fullName' | 'username' | 'email' | 'bio' | 'location'
  final String value;
  const ProfileFieldChangedEvent(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

// User tapped "Save" — persist changes
class ProfileSaveEvent extends ProfileEvent {
  final String? newPassword; // null if not changing password
  const ProfileSaveEvent({this.newPassword});
  @override
  List<Object?> get props => [newPassword];
}

// User changed avatar or cover image
class ProfileImageChangedEvent extends ProfileEvent {
  final bool   isCover; // false = avatar
  final String path;
  const ProfileImageChangedEvent({required this.isCover, required this.path});
  @override
  List<Object?> get props => [isCover, path];
}

// User switched tab (overview / treks / stories / saved)
class ProfileTabChangedEvent extends ProfileEvent {
  final ProfileTab tab;
  const ProfileTabChangedEvent(this.tab);
  @override
  List<Object?> get props => [tab];
}

// Dismiss save success/error snack
class ProfileSnackDismissedEvent extends ProfileEvent {
  const ProfileSnackDismissedEvent();
}