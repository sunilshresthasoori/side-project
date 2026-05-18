import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../bloc/profile_bloc.dart';
import '../../domain/model/profile_model.dart';

class ProfileEditForm extends StatefulWidget {
  final UserProfile draft;

  const ProfileEditForm({super.key, required this.draft});

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _passwordCtrl;
  late final TextEditingController _confirmCtrl;

  bool _showPasswordSection = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _fullNameCtrl = TextEditingController(text: widget.draft.fullName ?? '');
    _usernameCtrl = TextEditingController(text: widget.draft.username ?? '');
    _emailCtrl = TextEditingController(text: widget.draft.email ?? '');
    _bioCtrl = TextEditingController(text: widget.draft.bio ?? '');
    _locationCtrl = TextEditingController(text: widget.draft.location ?? '');
    _passwordCtrl = TextEditingController();
    _confirmCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _bioCtrl.dispose();
    _locationCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
        border: Border.all(color: AppColors.saffron.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                        gradient: AppGradients.saffronAccent,
                        borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 10),
                Text('Edit Profile',
                    style: GoogleFonts.syne(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Full Name
                _FormField(
                  controller: _fullNameCtrl,
                  label: 'Full Name',
                  hint: 'Your full name',
                  icon: Icons.person_outline_rounded,
                  onChanged: (v) => context
                      .read<ProfileBloc>()
                      .add(ProfileFieldChangedEvent('fullName', v)),
                ),
                const SizedBox(height: 14),

                // Username
                _FormField(
                  controller: _usernameCtrl,
                  label: 'Username',
                  hint: 'your.username',
                  icon: Icons.alternate_email_rounded,
                  prefix: '@',
                  onChanged: (v) => context
                      .read<ProfileBloc>()
                      .add(ProfileFieldChangedEvent('username', v)),
                ),
                const SizedBox(height: 14),

                // Email
                _FormField(
                  controller: _emailCtrl,
                  label: 'Email',
                  hint: 'you@example.com',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => context
                      .read<ProfileBloc>()
                      .add(ProfileFieldChangedEvent('email', v)),
                ),
                const SizedBox(height: 14),

                // Location
                _FormField(
                  controller: _locationCtrl,
                  label: 'Location',
                  hint: 'City, Country',
                  icon: Icons.location_on_outlined,
                  onChanged: (v) => context
                      .read<ProfileBloc>()
                      .add(ProfileFieldChangedEvent('location', v)),
                ),
                const SizedBox(height: 14),

                // Bio (multiline)
                _FormField(
                  controller: _bioCtrl,
                  label: 'Bio',
                  hint: 'Tell the trekking community about yourself…',
                  icon: Icons.edit_note_rounded,
                  maxLines: 4,
                  maxLength: 160,
                  onChanged: (v) => context
                      .read<ProfileBloc>()
                      .add(ProfileFieldChangedEvent('bio', v)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.divider),

          //  Password section (collapsible)
          GestureDetector(
            onTap: () =>
                setState(() => _showPasswordSection = !_showPasswordSection),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.slateGray.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(Icons.lock_outline_rounded,
                        size: 16, color: AppColors.slateGray),
                  ),
                  const SizedBox(width: 12),
                  Text('Change Password',
                      style: GoogleFonts.syne(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _showPasswordSection ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textLight),
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _showPasswordSection
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  _FormField(
                    controller: _passwordCtrl,
                    label: 'New Password',
                    hint: 'Min 8 characters',
                    icon: Icons.lock_outline_rounded,
                    obscureText: _obscurePassword,
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: AppColors.textLight),
                    ),
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 14),
                  _FormField(
                    controller: _confirmCtrl,
                    label: 'Confirm Password',
                    hint: 'Repeat new password',
                    icon: Icons.lock_outline_rounded,
                    obscureText: _obscureConfirm,
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      child: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: AppColors.textLight),
                    ),
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 16),
                  // Update password button
                  GestureDetector(
                    onTap: () {
                      if (_passwordCtrl.text == _confirmCtrl.text &&
                          _passwordCtrl.text.length >= 8) {
                        context.read<ProfileBloc>().add(
                            ProfileSaveEvent(newPassword: _passwordCtrl.text));
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.slateGray.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                            color: AppColors.slateGray.withOpacity(0.3)),
                      ),
                      child: Center(
                        child: Text('Update Password',
                            style: GoogleFonts.syne(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slateGray)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

//  FORM FIELD

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? prefix;
  final int maxLines;
  final int? maxLength;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.onChanged,
    this.prefix,
    this.maxLines = 1,
    this.maxLength,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSub,
              letterSpacing: 0.5),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.snowFog,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColors.divider),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: maxLines,
            maxLength: maxLength,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style:
                GoogleFonts.dmSans(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  GoogleFonts.dmSans(fontSize: 14, color: AppColors.textLight),
              prefixIcon: Icon(icon, size: 17, color: AppColors.textLight),
              prefixText: prefix,
              prefixStyle: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.glacierBlue,
                  fontWeight: FontWeight.w700),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              counterStyle:
                  GoogleFonts.dmSans(fontSize: 10, color: AppColors.textLight),
            ),
          ),
        ),
      ],
    );
  }
}
