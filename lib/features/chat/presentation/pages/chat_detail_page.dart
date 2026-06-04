import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/chat_detail_bloc.dart';
import '../../domain/model/chat.dart';
import '../widgets/chat_widgets.dart';
import '../widgets/message_composer.dart';

class ChatDetailPage extends StatelessWidget {
  final Conversation conversation;

  const ChatDetailPage({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChatDetailBloc()..add(ChatDetailFetchEvent(conversation.id)),
      child: _ChatDetailView(conversation: conversation),
    );
  }
}

//  MAIN VIEW

class _ChatDetailView extends StatelessWidget {
  final Conversation conversation;

  const _ChatDetailView({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset = true by default
      // This pushes the composer up when the keyboard appears
      backgroundColor: AppColors.glacierWhite,
      body: Column(
        children: [
          //  Sticky header
          ChatHeader(conversation: conversation),

          //  Message list
          const Expanded(child: _MessageList()),

          //  Composer (reply preview + input row)
          BlocBuilder<ChatDetailBloc, ChatDetailState>(
            builder: (context, state) => switch (state) {
              ChatDetailLoaded s => MessageComposer(
                  replyToMessage: s.replyToMessage,
                  isSending: s.isSending,
                ),
              _ => const MessageComposer(isSending: false),
            },
          ),
        ],
      ),
    );
  }
}

//  MESSAGE LIST

class _MessageList extends StatefulWidget {
  const _MessageList();

  @override
  State<_MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<_MessageList> {
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  // Scroll to bottom whenever messages change
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatDetailBloc, ChatDetailState>(
      // Only re-render when message list changes
      listenWhen: (prev, next) =>
          next is ChatDetailLoaded &&
          (prev is! ChatDetailLoaded ||
              (prev).messages.length != next.messages.length),
      listener: (_, __) => _scrollToBottom(),
      builder: (context, state) => switch (state) {
        ChatDetailInitial() || ChatDetailLoading() => _LoadingMessages(),
        ChatDetailError e => _ErrorMessages(message: e.message),
        ChatDetailLoaded s => _MessageScroll(
            messages: s.messages,
            scrollCtrl: _scrollCtrl,
          ),
        _ => _LoadingMessages(),
      },
    );
  }
}

//  MESSAGE SCROLL VIEW

class _MessageScroll extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollCtrl;

  const _MessageScroll({required this.messages, required this.scrollCtrl});

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) return _EmptyChat();

    // Build items list with date separators injected between day boundaries
    final items = <_ChatItem>[];
    DateTime? lastDate;

    for (int i = 0; i < messages.length; i++) {
      final msg = messages[i];
      final msgDate = DateTime(
        msg.timestamp.year,
        msg.timestamp.month,
        msg.timestamp.day,
      );

      // Inject date separator when day changes
      if (lastDate == null || msgDate != lastDate) {
        items.add(_ChatItem.separator(msgDate));
        lastDate = msgDate;
      }

      // Show avatar only on first message of a group from same sender
      final isFirstOfGroup = i == 0 ||
          messages[i - 1].senderId != msg.senderId ||
          msg.timestamp.difference(messages[i - 1].timestamp).inMinutes > 5;

      items.add(_ChatItem.message(msg, showAvatar: isFirstOfGroup));
    }

    return ListView.builder(
      controller: scrollCtrl,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];

        if (item.isSeparator) {
          return DateSeparator(date: item.date!);
        }

        final prev = i > 0 ? items[i - 1] : null;
        final sideChanged = prev != null &&
            !prev.isSeparator &&
            prev.message!.isMe != item.message!.isMe;

        return Padding(
          padding: EdgeInsets.only(top: sideChanged ? 12 : 0),
          child: MessageBubble(
            message: item.message!,
            showAvatar: item.showAvatar,
          ),
        );
      },
    );
  }
}

//  CHAT ITEM (union type helper)

class _ChatItem {
  final ChatMessage? message;
  final DateTime? date;
  final bool isSeparator;
  final bool showAvatar;

  const _ChatItem._({
    this.message,
    this.date,
    required this.isSeparator,
    this.showAvatar = false,
  });

  factory _ChatItem.message(ChatMessage msg, {bool showAvatar = false}) =>
      _ChatItem._(message: msg, isSeparator: false, showAvatar: showAvatar);

  factory _ChatItem.separator(DateTime date) =>
      _ChatItem._(date: date, isSeparator: true);
}

//  LOADING STATE

class _LoadingMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // Simulate received messages (left)
        _shimmerRow(isMe: false),
        const SizedBox(height: 12),
        _shimmerRow(isMe: false, wide: true),
        const SizedBox(height: 20),
        // Sent messages (right)
        _shimmerRow(isMe: true),
        const SizedBox(height: 12),
        _shimmerRow(isMe: true, wide: true),
        const SizedBox(height: 20),
        _shimmerRow(isMe: false, wide: true),
        const SizedBox(height: 12),
        _shimmerRow(isMe: false),
        const SizedBox(height: 20),
        _shimmerRow(isMe: true),
      ],
    );
  }

  Widget _shimmerRow({required bool isMe, bool wide = false}) {
    final width = wide ? 200.0 : 130.0;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe) ...[
          const ShimmerBox(width: 28, height: 28, radius: 14),
          const SizedBox(width: 8),
        ],
        ShimmerBox(width: width, height: 44, radius: AppRadius.lg),
      ],
    );
  }
}

//  EMPTY CHAT

class _EmptyChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              gradient: AppGradients.tealAccent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chat_bubble_outline_rounded,
                color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Send a message to start the conversation!',
            style: AppTypography.body(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

//  ERROR STATE

class _ErrorMessages extends StatelessWidget {
  final String message;

  const _ErrorMessages({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 48, color: AppColors.textLight),
            const SizedBox(height: 12),
            Text('Could not load messages',
                style: AppTypography.headline(context)),
            const SizedBox(height: 8),
            Text(message,
                style: AppTypography.body(context),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => context.read<ChatDetailBloc>().add(
                    ChatDetailFetchEvent(
                      (context.read<ChatDetailBloc>().state as ChatDetailError)
                          .message,
                    ),
                  ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
