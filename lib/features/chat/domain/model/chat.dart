import 'package:equatable/equatable.dart';

//  MESSAGE STATUS
enum MessageStatus { sending, sent, delivered, read }

enum MessageType { text, image, trekCard, location, voiceNote }
//  CHAT MESSAGE

class ChatMessage extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;
  final bool isMe;
  final String? replyToId; // id of message being replied to
  final String? replyPreview; // short text of replied message
  final String? mediaPath; // for image/voice messages

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.isMe,
    this.type = MessageType.text,
    this.status = MessageStatus.read,
    this.replyToId,
    this.replyPreview,
    this.mediaPath,
  });

  @override
  List<Object?> get props => [id, status];
}

//  CONVERSATION PARTICIPANT

class ChatParticipant extends Equatable {
  final String id;
  final String name;
  final String avatarPath;
  final bool isOnline;
  final DateTime? lastSeen;
  final String? tagline; //

  const ChatParticipant({
    required this.id,
    required this.name,
    required this.avatarPath,
    this.isOnline = false,
    this.lastSeen,
    this.tagline,
  });

  String get lastSeenText {
    if (isOnline) return 'Online';
    if (lastSeen == null) return 'Offline';
    final diff = DateTime.now().difference(lastSeen!);
    if (diff.inMinutes < 2) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  List<Object?> get props => [id, isOnline];
}

//  CONVERSATION

class Conversation extends Equatable {
  final String id;
  final List<ChatParticipant> participants;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final bool isGroup;
  final String? groupName;
  final String? groupAvatarPath;
  final bool isMuted;
  final bool isPinned;

  const Conversation({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.unreadCount = 0,
    this.isGroup = false,
    this.groupName,
    this.groupAvatarPath,
    this.isMuted = false,
    this.isPinned = false,
  });

  String get displayName => isGroup
      ? (groupName ?? 'Group Chat')
      : (participants.firstOrNull?.name ?? 'Unknown');

  String get displayAvatarPath => isGroup
      ? (groupAvatarPath ?? '')
      : (participants.firstOrNull?.avatarPath ?? '');

  bool get isOnline =>
      !isGroup && (participants.firstOrNull?.isOnline ?? false);

  String get statusText {
    if (isGroup) return '${participants.length} members';
    return participants.firstOrNull?.lastSeenText ?? '';
  }

  @override
  List<Object?> get props => [id, unreadCount, lastMessage];
}
