
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../bloc/chat_bloc.dart';

import '../../bloc/chat_event.dart';
import '../../domain/model/chat.dart';


class MessageComposer extends StatefulWidget {
  final ChatMessage? replyToMessage;
  final bool         isSending;

  const MessageComposer({
    super.key,
    this.replyToMessage,
    required this.isSending,
  });

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final _controller = TextEditingController();
  final _focus      = FocusNode();
  bool  _hasText    = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
      context.read<ChatDetailBloc>().add(ChatDetailMessageChangedEvent(_controller.text));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _send() {
    if (!_hasText || widget.isSending) return;
    context.read<ChatDetailBloc>().add(const ChatDetailSendEvent());
    _controller.clear();
    setState(() => _hasText = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.slateGray.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //  Reply banner 
            if (widget.replyToMessage != null) _ReplyBanner(message: widget.replyToMessage!),

            //  Composer row 
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Attachment
                  _ComposerIcon(
                    icon: Icons.attach_file_rounded,
                    color: AppColors.slateGray,
                    onTap: () {},
                  ),
                  const SizedBox(width: 6),

                  // Camera
                  _ComposerIcon(
                    icon: Icons.camera_alt_outlined,
                    color: AppColors.slateGray,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),

                  // Text field
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 120),
                      decoration: BoxDecoration(
                        color: AppColors.snowFog,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              controller:  _controller,
                              focusNode:   _focus,
                              maxLines:    null,
                              minLines:    1,
                              textCapitalization: TextCapitalization.sentences,
                              style: GoogleFonts.dmSans(
                                fontSize: 14, color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText:  'Message…',
                                hintStyle: GoogleFonts.dmSans(
                                  fontSize: 14, color: AppColors.textLight,
                                ),
                                border:     InputBorder.none,
                                contentPadding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
                              ),
                            ),
                          ),
                          // Emoji button
                          Padding(
                            padding: const EdgeInsets.only(right: 8, bottom: 8),
                            child: GestureDetector(
                              onTap: () {},
                              child: const Text('😊', style: TextStyle(fontSize: 20)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Send / mic button
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                    child: _hasText
                        ? _SendButton(key: const ValueKey('send'), onTap: _send, isSending: widget.isSending)
                        : _ComposerIcon(
                      key: const ValueKey('mic'),
                      icon:  Icons.mic_rounded,
                      color: AppColors.slateGray,
                      onTap: () {},
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
}

//  REPLY BANNER 

class _ReplyBanner extends StatelessWidget {
  final ChatMessage message;
  const _ReplyBanner({required this.message});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
    decoration: BoxDecoration(
      color: AppColors.glacierBlue.withOpacity(0.06),
      border: const Border(
        top:  BorderSide(color: AppColors.divider),
        left: BorderSide(color: AppColors.glacierBlue, width: 3),
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.isMe ? 'Replying to yourself' : 'Replying',
                style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.glacierBlue),
              ),
              const SizedBox(height: 2),
              Text(
                message.content,
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textSub),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.read<ChatDetailBloc>().add(const ChatDetailReplyClearedEvent()),
          child: Container(
            width: 24, height: 24,
            decoration: BoxDecoration(color: AppColors.snowFog, shape: BoxShape.circle),
            child: const Icon(Icons.close_rounded, size: 14, color: AppColors.textLight),
          ),
        ),
      ],
    ),
  );
}

//  SEND BUTTON 

class _SendButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool         isSending;
  const _SendButton({super.key, required this.onTap, required this.isSending});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 44, height: 44,
      decoration: BoxDecoration(
        gradient: AppGradients.tealAccent,
        shape: BoxShape.circle,
        boxShadow: AppShadows.button,
      ),
      child: isSending
          ? const Padding(
        padding: EdgeInsets.all(12),
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      )
          : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
    ),
  );
}

//  COMPOSER ICON 

class _ComposerIcon extends StatelessWidget {
  final IconData     icon;
  final Color        color;
  final VoidCallback onTap;
  const _ComposerIcon({super.key, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: 38, height: 38,
      child: Icon(icon, size: 22, color: color),
    ),
  );
}