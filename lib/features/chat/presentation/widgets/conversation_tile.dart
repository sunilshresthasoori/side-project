import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/conversation_bloc.dart';
import '../../domain/model/chat.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showActions(context),
      child: Container(
        color: conversation.isPinned
            ? AppColors.saffron.withValues(alpha: 0.04)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            _ConvAvatar(conversation: conversation),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name row
                  Row(
                    children: [
                      if (conversation.isPinned)
                        const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(Icons.push_pin_rounded,
                              size: 12, color: AppColors.saffron),
                        ),
                      Expanded(
                        child: Text(
                          conversation.displayName,
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w800
                                : FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Timestamp
                      Text(
                        _formatTime(conversation.lastMessage?.timestamp),
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: conversation.unreadCount > 0
                              ? AppColors.saffron
                              : AppColors.textLight,
                          fontWeight: conversation.unreadCount > 0
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Preview row
                  Row(
                    children: [
                      // Read receipt for sent messages
                      if (conversation.lastMessage?.isMe == true)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: _ReadReceipt(
                              status: conversation.lastMessage!.status),
                        ),
                      Expanded(
                        child: Text(
                          conversation.lastMessage?.content ?? '',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: conversation.unreadCount > 0
                                ? AppColors.textPrimary
                                : AppColors.textSub,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Mute icon
                      if (conversation.isMuted)
                        const Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(Icons.volume_off_rounded,
                              size: 14, color: AppColors.textLight),
                        ),

                      // Unread badge
                      if (conversation.unreadCount > 0)
                        Container(
                          constraints: const BoxConstraints(minWidth: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: conversation.isMuted
                                ? const LinearGradient(colors: [
                                    AppColors.textLight,
                                    AppColors.slateGray
                                  ])
                                : AppGradients.saffronAccent,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            conversation.unreadCount > 99
                                ? '99+'
                                : '${conversation.unreadCount}',
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ConversationsBloc>(),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Text(conversation.displayName,
                    style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
              ),
              const SizedBox(height: 12),
              _ActionTile(
                icon: conversation.isPinned
                    ? Icons.push_pin_outlined
                    : Icons.push_pin_rounded,
                label: conversation.isPinned
                    ? 'Unpin Conversation'
                    : 'Pin Conversation',
                color: AppColors.glacierBlue,
                onTap: () {
                  context
                      .read<ConversationsBloc>()
                      .add(ConversationPinnedEvent(conversation.id));
                  Navigator.pop(context);
                },
              ),
              _ActionTile(
                icon: conversation.isMuted
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                label: conversation.isMuted ? 'Unmute' : 'Mute Notifications',
                color: AppColors.slateGray,
                onTap: () {
                  context
                      .read<ConversationsBloc>()
                      .add(ConversationMutedEvent(conversation.id));
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) {
      return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][dt.weekday - 1];
    }
    return '${dt.day}/${dt.month}';
  }
}

//  CONVERSATION AVATAR

class _ConvAvatar extends StatelessWidget {
  final Conversation conversation;

  const _ConvAvatar({required this.conversation});

  @override
  Widget build(BuildContext context) {
    if (conversation.isGroup) {
      // Group: stacked mini avatars
      final shown = conversation.participants.take(2).toList();
      return SizedBox(
        width: 52,
        height: 52,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: _AvatarCircle(
                  path: shown.length > 1 ? shown[1].avatarPath : '', size: 38),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.glacierWhite, width: 2),
                ),
                child: _AvatarCircle(path: shown[0].avatarPath, size: 34),
              ),
            ),
          ],
        ),
      );
    }

    // Single: avatar with online ring
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: conversation.isOnline
                  ? AppColors.electricTeal.withValues(alpha: 0.5)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: _AvatarCircle(path: conversation.displayAvatarPath, size: 50),
        ),
        if (conversation.isOnline)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.electricTeal,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.glacierWhite, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final String path;
  final double size;

  const _AvatarCircle({required this.path, required this.size});

  @override
  Widget build(BuildContext context) => ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: path.isNotEmpty
              ? TrekAssetImage(
                  assetPath: path, fit: BoxFit.cover, width: size, height: size)
              : Container(
                  decoration:
                      const BoxDecoration(gradient: AppGradients.tealAccent),
                  child: const Icon(Icons.person_rounded,
                      color: Colors.white, size: 20),
                ),
        ),
      );
}

//  READ RECEIPT

class _ReadReceipt extends StatelessWidget {
  final MessageStatus status;

  const _ReadReceipt({required this.status});

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      MessageStatus.sending => const Icon(Icons.access_time_rounded,
          size: 13, color: AppColors.textLight),
      MessageStatus.sent =>
        const Icon(Icons.check_rounded, size: 13, color: AppColors.textLight),
      MessageStatus.delivered => const Icon(Icons.done_all_rounded,
          size: 13, color: AppColors.textLight),
      MessageStatus.read => const Icon(Icons.done_all_rounded,
          size: 13, color: AppColors.electricTeal),
    };
  }
}

//  ACTION TILE

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(children: [
            Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm)),
                child: Icon(icon, size: 18, color: color)),
            const SizedBox(width: 14),
            Text(label,
                style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ]),
        ),
      );
}
