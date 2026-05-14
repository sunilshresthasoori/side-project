import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';

class SharePanel extends StatelessWidget {
  final VoidCallback onShare;

  const SharePanel({super.key, required this.onShare});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Share this story',
            style: GoogleFonts.syne(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ShareButton(
                label: 'Facebook',
                icon: Icons.facebook,
                onTap: onShare,
              ),
              _ShareButton(
                label: 'Twitter',
                icon: Icons.close,
                onTap: onShare,
              ),
              _ShareButton(
                label: 'LinkedIn',
                icon: Icons.work_outline,
                onTap: onShare,
              ),
              _ShareButton(
                label: 'WhatsApp',
                icon: Icons.chat_rounded,
                onTap: onShare,
              ),
              _ShareButton(
                label: 'Copy Link',
                icon: Icons.link_rounded,
                onTap: onShare,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ShareButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.glacierWhite,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
