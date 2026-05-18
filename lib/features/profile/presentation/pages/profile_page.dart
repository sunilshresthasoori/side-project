import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/profile_bloc.dart';
import '../../domain/model/profile_model.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_edit_form.dart';
import '../widgets/profile_tabs.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(const ProfileFetchEvent()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      // Listen for save success/error → show SnackBar
      listener: (context, state) {
        if (state is ProfileLoaded) {
          if (state.saveSuccessMsg != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    Text(state.saveSuccessMsg!,
                        style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w600, color: Colors.white)),
                  ]),
                  backgroundColor: const Color(0xFF2ECC71),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm)),
                  duration: const Duration(seconds: 3),
                ),
              );
            context.read<ProfileBloc>().add(const ProfileSnackDismissedEvent());
          }
          if (state.saveErrorMsg != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(children: [
                    const Icon(Icons.error_outline_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(state.saveErrorMsg!,
                            style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w600,
                                color: Colors.white))),
                  ]),
                  backgroundColor: AppColors.coral,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm)),
                ),
              );
            context.read<ProfileBloc>().add(const ProfileSnackDismissedEvent());
          }
        }
      },
      builder: (context, state) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

        return Scaffold(
          backgroundColor: AppColors.glacierWhite,
          body: switch (state) {
            ProfileInitial() || ProfileLoading() => _LoadingView(),
            ProfileError e => _ErrorView(message: e.message),
            ProfileLoaded s => _LoadedView(state: s),
            _ => const _ErrorView(message: 'Unexpected profile state'),
          },
        );
      },
    );
  }
}

//  LOADED VIEW

class _LoadedView extends StatelessWidget {
  final ProfileLoaded state;
  const _LoadedView({required this.state});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        //  Profile header (cover + avatar + stats + badges)
        SliverToBoxAdapter(
          child: ProfileHeader(
            profile: state.displayProfile,
            isEditing: state.isEditing,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        //  Edit form (shown when isEditing)
        if (state.isEditing)
          SliverToBoxAdapter(
            child: Column(
              children: [
                ProfileEditForm(draft: state.displayProfile),
                const SizedBox(height: 16),
                // Inline save/cancel bar
                _SaveBar(isSaving: state.isSaving),
                const SizedBox(height: 20),
              ],
            ),
          ),

        //  Sticky Tab Bar
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyTabDelegate(activeTab: state.activeTab),
        ),

        //  Tab content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ProfileTabBody(state: state),
          ),
        ),
      ],
    );
  }
}

//  SAVE BAR

class _SaveBar extends StatelessWidget {
  final bool isSaving;
  const _SaveBar({required this.isSaving});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => context
                    .read<ProfileBloc>()
                    .add(const ProfileEditCancelledEvent()),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Center(
                    child: Text('Cancel',
                        style: GoogleFonts.syne(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSub)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: isSaving
                    ? null
                    : () => context
                        .read<ProfileBloc>()
                        .add(const ProfileSaveEvent()),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: AppGradients.saffronAccent,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    boxShadow: isSaving ? [] : AppShadows.button,
                  ),
                  child: Center(
                    child: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.check_rounded,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text('Save Changes',
                                style: GoogleFonts.syne(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

//  STICKY TAB DELEGATE

class _StickyTabDelegate extends SliverPersistentHeaderDelegate {
  final ProfileTab activeTab;
  const _StickyTabDelegate({required this.activeTab});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glacierWhite,
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                    color: AppColors.slateGray.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ]
            : [],
      ),
      child: ProfileTabBar(activeTab: activeTab),
    );
  }

  @override
  double get maxExtent => 48;
  @override
  double get minExtent => 48;
  @override
  bool shouldRebuild(_StickyTabDelegate old) => old.activeTab != activeTab;
}

//  LOADING VIEW

class _LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
        child: Column(children: [
          ShimmerBox(width: double.infinity, height: 185, radius: 0),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(children: [
              Row(children: [
                ShimmerBox(width: 90, height: 90, radius: 45),
                SizedBox(width: 16),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      ShimmerBox(width: 160, height: 22, radius: 8),
                      SizedBox(height: 8),
                      ShimmerBox(width: 100, height: 14, radius: 6),
                    ])),
              ]),
              SizedBox(height: 20),
              ShimmerBox(width: double.infinity, height: 80, radius: 12),
              SizedBox(height: 14),
              ShimmerBox(width: double.infinity, height: 60, radius: 12),
            ]),
          ),
        ]),
      );
}

//  ERROR VIEW

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.person_off_rounded,
                size: 56, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text('Could not load profile',
                style: AppTypography.headline(context)),
            const SizedBox(height: 8),
            Text(message,
                style: AppTypography.body(context),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<ProfileBloc>().add(const ProfileFetchEvent()),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ]),
        ),
      );
}
