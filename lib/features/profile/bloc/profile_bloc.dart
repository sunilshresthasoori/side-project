
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/repository/profile_mock_repository.dart';
import '../domain/model/profile_model.dart';


part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileMockRepository _repo;

  ProfileBloc({ProfileMockRepository? repo})
      : _repo = repo ?? ProfileMockRepository(),
        super(const ProfileInitial()) {
    on<ProfileFetchEvent>(_onFetch);
    on<ProfileEditStartedEvent>(_onEditStarted);
    on<ProfileEditCancelledEvent>(_onEditCancelled);
    on<ProfileFieldChangedEvent>(_onFieldChanged);
    on<ProfileSaveEvent>(_onSave);
    on<ProfileImageChangedEvent>(_onImageChanged);
    on<ProfileTabChangedEvent>(_onTabChanged);
    on<ProfileSnackDismissedEvent>(_onSnackDismissed);
  }

  Future<void> _onFetch(ProfileFetchEvent event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      final profile = await _repo.fetchProfile();
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  void _onEditStarted(ProfileEditStartedEvent event, Emitter<ProfileState> emit) {
    if (state is! ProfileLoaded) return;
    final s = state as ProfileLoaded;
    // Clone current profile into draft
    emit(s.copyWith(isEditing: true, draftProfile: s.profile));
  }

  void _onEditCancelled(ProfileEditCancelledEvent event, Emitter<ProfileState> emit) {
    if (state is! ProfileLoaded) return;
    emit((state as ProfileLoaded).copyWith(
      isEditing: false,
      clearDraft: true,
      clearError: true,
    ));
  }

  void _onFieldChanged(ProfileFieldChangedEvent event, Emitter<ProfileState> emit) {
    if (state is! ProfileLoaded) return;
    final s     = state as ProfileLoaded;
    final draft = s.draftProfile ?? s.profile;

    final updated = switch (event.field) {
      'fullName' => draft.copyWith(fullName: event.value.isEmpty ? null : event.value),
      'username' => draft.copyWith(username: event.value.isEmpty ? null : event.value),
      'email'    => draft.copyWith(email:    event.value.isEmpty ? null : event.value),
      'bio'      => draft.copyWith(bio:      event.value.isEmpty ? null : event.value),
      'location' => draft.copyWith(location: event.value.isEmpty ? null : event.value),
      _          => draft,
    };
    emit(s.copyWith(draftProfile: updated));
  }

  Future<void> _onSave(ProfileSaveEvent event, Emitter<ProfileState> emit) async {
    if (state is! ProfileLoaded) return;
    final s = state as ProfileLoaded;
    if (s.draftProfile == null) return;

    emit(s.copyWith(isSaving: true, clearError: true));
    try {
      final saved = await _repo.saveProfile(
        profile:     s.draftProfile!,
        newPassword: event.newPassword,
      );
      emit(s.copyWith(
        profile:        saved,
        isEditing:      false,
        isSaving:       false,
        clearDraft:     true,
        saveSuccessMsg: 'Profile updated successfully!',
      ));
    } catch (e) {
      emit(s.copyWith(
        isSaving:     false,
        saveErrorMsg: 'Failed to save: $e',
      ));
    }
  }

  void _onImageChanged(ProfileImageChangedEvent event, Emitter<ProfileState> emit) {
    if (state is! ProfileLoaded) return;
    final s     = state as ProfileLoaded;
    final draft = s.draftProfile ?? s.profile;
    final updated = event.isCover
        ? draft.copyWith(coverImage: event.path)
        : draft.copyWith(avatar: event.path);
    emit(s.copyWith(draftProfile: updated, isEditing: true));
  }

  void _onTabChanged(ProfileTabChangedEvent event, Emitter<ProfileState> emit) {
    if (state is! ProfileLoaded) return;
    emit((state as ProfileLoaded).copyWith(activeTab: event.tab));
  }

  void _onSnackDismissed(ProfileSnackDismissedEvent event, Emitter<ProfileState> emit) {
    if (state is! ProfileLoaded) return;
    emit((state as ProfileLoaded).copyWith(clearSuccess: true, clearError: true));
  }
}