

part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserProfile  profile;
  final UserProfile? draftProfile;   // non-null when in edit mode
  final bool         isEditing;
  final bool         isSaving;
  final ProfileTab   activeTab;
  final String?      saveSuccessMsg; // shown briefly after save
  final String?      saveErrorMsg;

  const ProfileLoaded({
    required this.profile,
    this.draftProfile,
    this.isEditing      = false,
    this.isSaving       = false,
    this.activeTab      = ProfileTab.overview,
    this.saveSuccessMsg,
    this.saveErrorMsg,
  });

  // The profile shown in the edit form — draft if editing, real if not
  UserProfile get displayProfile => draftProfile ?? profile;

  ProfileLoaded copyWith({
    UserProfile?  profile,
    UserProfile?  draftProfile,
    bool?         isEditing,
    bool?         isSaving,
    ProfileTab?   activeTab,
    String?       saveSuccessMsg,
    String?       saveErrorMsg,
    bool          clearDraft   = false,
    bool          clearSuccess = false,
    bool          clearError   = false,
  }) =>
      ProfileLoaded(
        profile:        profile        ?? this.profile,
        draftProfile:   clearDraft     ? null : (draftProfile ?? this.draftProfile),
        isEditing:      isEditing      ?? this.isEditing,
        isSaving:       isSaving       ?? this.isSaving,
        activeTab:      activeTab      ?? this.activeTab,
        saveSuccessMsg: clearSuccess   ? null : (saveSuccessMsg ?? this.saveSuccessMsg),
        saveErrorMsg:   clearError     ? null : (saveErrorMsg   ?? this.saveErrorMsg),
      );

  @override
  List<Object?> get props => [
    profile, draftProfile, isEditing, isSaving,
    activeTab, saveSuccessMsg, saveErrorMsg,
  ];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}