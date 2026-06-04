import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/chat_detail_bloc.dart';
import '../../domain/model/chat.dart';

//  CHAT HEADER

class ChatHeader extends StatelessWidget {
  final Conversation conversation;

  const ChatHeader({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.slateGray.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.snowFog,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 16, color: AppColors.slateGray),
                ),
              ),
              const SizedBox(width: 10),

              // Avatar
              _HeaderAvatar(conversation: conversation),
              const SizedBox(width: 10),

              // Name + status
              Expanded(
                child: GestureDetector(
                  onTap: () {}, // open contact/group info
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        conversation.displayName,
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          if (conversation.isOnline)
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: const BoxDecoration(
                                color: AppColors.electricTeal,
                                shape: BoxShape.circle,
                              ),
                            ),
                          Text(
                            conversation.statusText,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: conversation.isOnline
                                  ? AppColors.electricTeal
                                  : AppColors.textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Action icons
              _HeaderIcon(icon: Icons.videocam_outlined, onTap: () {}),
              _HeaderIcon(icon: Icons.call_outlined, onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  final Conversation conversation;
  const _HeaderAvatar({required this.conversation});

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          ClipOval(
            child: SizedBox(
              width: 40,
              height: 40,
              child: conversation.displayAvatarPath.isNotEmpty
                  ? TrekAssetImage(
                      assetPath: conversation.displayAvatarPath,
                      fit: BoxFit.cover)
                  : Container(
                      decoration: const BoxDecoration(
                          gradient: AppGradients.tealAccent),
                      child: const Icon(Icons.people_rounded,
                          color: Colors.white, size: 20),
                    ),
            ),
          ),
          if (conversation.isOnline)
            Positioned(
              bottom: 1,
              right: 1,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.electricTeal,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      );
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: AppColors.snowFog,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: 18, color: AppColors.slateGray),
        ),
      );
}

//  DATE SEPARATOR

class DateSeparator extends StatelessWidget {
  final DateTime date;
  const DateSeparator({super.key, required this.date});

  String get _label {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) {
      return [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ][date.weekday - 1];
    }
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Container(height: 0.5, color: AppColors.divider)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.snowFog,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: AppColors.divider),
            ),
            child: Text(
              _label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textLight,
              ),
            ),
          ),
          Expanded(child: Container(height: 0.5, color: AppColors.divider)),
        ],
      ),
    );
  }
}

//  MESSAGE BUBBLE

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showAvatar; // show sender avatar (first of a group)

  const MessageBubble({
    super.key,
    required this.message,
    this.showAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showMessageActions(context),
      child: Padding(
        padding: EdgeInsets.only(
          left: message.isMe ? 60 : 8,
          right: message.isMe ? 8 : 60,
          bottom: 3,
        ),
        child: Row(
          mainAxisAlignment:
              message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Sender avatar (received messages)
            if (!message.isMe)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: showAvatar
                    ? ClipOval(
                        child: TrekAssetImage(
                          assetPath: 'assets/images/avatar_karma.jpg',
                          width: 28,
                          height: 28,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const SizedBox(width: 28),
              ),

            // Bubble
            Flexible(
              child: Column(
                crossAxisAlignment: message.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Reply preview
                  if (message.replyPreview != null)
                    _ReplyPreview(
                        preview: message.replyPreview!, isMe: message.isMe),

                  // Main bubble
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: message.isMe ? AppGradients.tealAccent : null,
                      color: message.isMe ? null : AppColors.cardWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(AppRadius.lg),
                        topRight: const Radius.circular(AppRadius.lg),
                        bottomLeft: Radius.circular(
                            message.isMe ? AppRadius.lg : AppRadius.xs),
                        bottomRight: Radius.circular(
                            message.isMe ? AppRadius.xs : AppRadius.lg),
                      ),
                      boxShadow: AppShadows.card,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Message text
                        Text(
                          message.content,
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: message.isMe
                                ? Colors.white
                                : AppColors.textPrimary,
                            height: 1.45,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Timestamp + read receipt row
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatTime(message.timestamp),
                              style: GoogleFonts.dmSans(
                                fontSize: 10,
                                color: message.isMe
                                    ? Colors.white.withOpacity(0.7)
                                    : AppColors.textLight,
                              ),
                            ),
                            if (message.isMe) ...[
                              const SizedBox(width: 4),
                              _BubbleReceipt(status: message.status),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageActions(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ChatDetailBloc>(),
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
              // Message preview
              Container(
                margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.snowFog,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  message.content,
                  style: GoogleFonts.dmSans(
                      fontSize: 13, color: AppColors.textSub),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _MsgAction(
                  icon: Icons.reply_rounded,
                  label: 'Reply',
                  color: AppColors.glacierBlue,
                  onTap: () {
                    context
                        .read<ChatDetailBloc>()
                        .add(ChatDetailReplySetEvent(message));
                    Navigator.pop(context);
                  }),
              _MsgAction(
                  icon: Icons.copy_rounded,
                  label: 'Copy Text',
                  color: AppColors.slateGray,
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: message.content));
                    Navigator.pop(context);
                  }),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

class _BubbleReceipt extends StatelessWidget {
  final MessageStatus status;
  const _BubbleReceipt({required this.status});

  @override
  Widget build(BuildContext context) => switch (status) {
        MessageStatus.sending => const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
                strokeWidth: 1.5, color: Colors.white54)),
        MessageStatus.sent =>
          const Icon(Icons.check_rounded, size: 14, color: Colors.white70),
        MessageStatus.delivered =>
          const Icon(Icons.done_all_rounded, size: 14, color: Colors.white70),
        MessageStatus.read =>
          const Icon(Icons.done_all_rounded, size: 14, color: Colors.white),
      };
}

class _ReplyPreview extends StatelessWidget {
  final String preview;
  final bool isMe;
  const _ReplyPreview({required this.preview, required this.isMe});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.electricTeal.withOpacity(0.2)
              : AppColors.snowFog,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border(
              left: BorderSide(
                  color: isMe
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.glacierBlue,
                  width: 3)),
        ),
        child: Text(
          preview,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            color: isMe ? Colors.white.withOpacity(0.8) : AppColors.textSub,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
}

class _MsgAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MsgAction(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(children: [
            Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
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
