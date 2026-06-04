import 'dart:async';
import '../../domain/model/chat.dart';

class ChatMockRepository {
  //  CONVERSATIONS LIST
  Future<List<Conversation>> fetchConversations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _conversations;
  }

  //  MESSAGES FOR A CONVERSATION
  Future<List<ChatMessage>> fetchMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return (_messagesByConversation[conversationId] ?? [])
        // .reversed
        .toList(); // oldest first
  }

  //  SEND MESSAGE (mock — returns sent message)
  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String content,
    String? replyToId,
    String? replyPreview,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'me',
      content: content,
      timestamp: DateTime.now(),
      isMe: true,
      status: MessageStatus.sent,
      replyToId: replyToId,
      replyPreview: replyPreview,
    );
  }

  //  MOCK DATA

  static final _now = DateTime.now();

  static final List<Conversation> _conversations = [
    Conversation(
      id: 'conv_1',
      participants: const [
        ChatParticipant(
            id: 'p1',
            name: 'Karma Tenzing',
            avatarPath: 'assets/images/avatar_karma.jpg',
            isOnline: true,
            tagline: 'EBC ✓  Manaslu ✓  Annapurna ✓'),
      ],
      lastMessage: ChatMessage(
        id: 'm_last_1',
        conversationId: 'conv_1',
        senderId: 'p1',
        content: 'The Thorong La pass was brutal yesterday 😅 Glad we made it!',
        timestamp: _now.subtract(const Duration(minutes: 4)),
        isMe: false,
        status: MessageStatus.read,
      ),
      unreadCount: 2,
      isPinned: true,
    ),
    Conversation(
      id: 'conv_2',
      participants: const [
        ChatParticipant(
            id: 'p2',
            name: 'Priya Sharma',
            avatarPath: 'assets/images/avatar_priya.jpg',
            isOnline: true,
            tagline: 'Himalayan photographer 📸'),
      ],
      lastMessage: ChatMessage(
        id: 'm_last_2',
        conversationId: 'conv_2',
        senderId: 'me',
        content: 'Sent you the packing list for the Langtang trek 📋',
        timestamp: _now.subtract(const Duration(hours: 1)),
        isMe: true,
        status: MessageStatus.delivered,
      ),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv_3',
      isGroup: true,
      groupName: '🏔 EBC Squad 2025',
      groupAvatarPath: 'assets/images/trek_everest.jpg',
      participants: const [
        ChatParticipant(
            id: 'p3',
            name: 'Josh Miller',
            avatarPath: 'assets/images/avatar_josh.jpg'),
        ChatParticipant(
            id: 'p4',
            name: 'Aiko Nakamura',
            avatarPath: 'assets/images/avatar_aiko.jpg'),
        ChatParticipant(
            id: 'p1',
            name: 'Karma Tenzing',
            avatarPath: 'assets/images/avatar_karma.jpg'),
      ],
      lastMessage: ChatMessage(
        id: 'm_last_3',
        conversationId: 'conv_3',
        senderId: 'p3',
        content: 'Josh: Who\'s landing in Kathmandu on March 10?',
        timestamp: _now.subtract(const Duration(hours: 3)),
        isMe: false,
        status: MessageStatus.read,
      ),
      unreadCount: 5,
    ),
    Conversation(
      id: 'conv_4',
      participants: [
        ChatParticipant(
            id: 'p4',
            name: 'Aiko Nakamura',
            avatarPath: 'assets/images/avatar_aiko.jpg',
            isOnline: false,
            lastSeen: _now.subtract(const Duration(hours: 2)),
            tagline: 'Winter trekker | Gear reviewer'),
      ],
      lastMessage: ChatMessage(
        id: 'm_last_4',
        conversationId: 'conv_4',
        senderId: 'p4',
        content: 'That Manaslu gear list you shared was 🔥 Saving it!',
        timestamp: _now.subtract(const Duration(hours: 5)),
        isMe: false,
        status: MessageStatus.read,
      ),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv_5',
      isGroup: true,
      groupName: '🌿 Nepal Trekkers Network',
      groupAvatarPath: 'assets/images/cat_cultural.jpg',
      participants: const [
        ChatParticipant(
            id: 'p1',
            name: 'Karma',
            avatarPath: 'assets/images/avatar_karma.jpg'),
        ChatParticipant(
            id: 'p2',
            name: 'Priya',
            avatarPath: 'assets/images/avatar_priya.jpg'),
        ChatParticipant(
            id: 'p4',
            name: 'Aiko',
            avatarPath: 'assets/images/avatar_aiko.jpg'),
        ChatParticipant(
            id: 'p3',
            name: 'Josh',
            avatarPath: 'assets/images/avatar_josh.jpg'),
      ],
      lastMessage: ChatMessage(
        id: 'm_last_5',
        conversationId: 'conv_5',
        senderId: 'p2',
        content: 'Priya: Monsoon trails update posted in community stories 🌧',
        timestamp: _now.subtract(const Duration(days: 1)),
        isMe: false,
        status: MessageStatus.read,
      ),
      unreadCount: 12,
      isMuted: true,
    ),
    Conversation(
      id: 'conv_6',
      participants: [
        ChatParticipant(
            id: 'p3',
            name: 'Josh Miller',
            avatarPath: 'assets/images/avatar_josh.jpg',
            isOnline: false,
            lastSeen: _now.subtract(const Duration(days: 1))),
      ],
      lastMessage: ChatMessage(
        id: 'm_last_6',
        conversationId: 'conv_6',
        senderId: 'me',
        content: 'Great meeting you on the Pikey Peak trail! Stay safe 🙏',
        timestamp: _now.subtract(const Duration(days: 2)),
        isMe: true,
        status: MessageStatus.read,
      ),
      unreadCount: 0,
    ),
  ];

  static final Map<String, List<ChatMessage>> _messagesByConversation = {
    'conv_1': [
      ChatMessage(
          id: 'm1_1',
          conversationId: 'conv_1',
          senderId: 'me',
          content: 'Hey Karma! How\'s the Annapurna Circuit going?',
          timestamp: _now.subtract(const Duration(days: 2, hours: 3)),
          isMe: true,
          status: MessageStatus.read),
      ChatMessage(
          id: 'm1_2',
          conversationId: 'conv_1',
          senderId: 'p1',
          content:
              'It\'s incredible! Just reached Manang after 4 days. The altitude is hitting though 😅',
          timestamp:
              _now.subtract(const Duration(days: 2, hours: 2, minutes: 45)),
          isMe: false),
      ChatMessage(
          id: 'm1_3',
          conversationId: 'conv_1',
          senderId: 'me',
          content:
              'Take the rest day in Manang seriously — your lungs will thank you later!',
          timestamp:
              _now.subtract(const Duration(days: 2, hours: 2, minutes: 30)),
          isMe: true,
          status: MessageStatus.read),
      ChatMessage(
          id: 'm1_4',
          conversationId: 'conv_1',
          senderId: 'p1',
          content:
              'Planning to hike to the Ice Lake tomorrow for acclimatization. Did you do it?',
          timestamp: _now.subtract(const Duration(days: 2, hours: 1)),
          isMe: false),
      ChatMessage(
          id: 'm1_5',
          conversationId: 'conv_1',
          senderId: 'me',
          content:
              'Yes! 4600m and worth every step. Get there by 8am before clouds roll in 🌄',
          timestamp: _now.subtract(const Duration(days: 2)),
          isMe: true,
          status: MessageStatus.read),
      ChatMessage(
          id: 'm1_6',
          conversationId: 'conv_1',
          senderId: 'p1',
          content:
              'Perfect. What\'s the teahouse situation at Thorong Phedi like?',
          timestamp: _now.subtract(const Duration(hours: 6)),
          isMe: false),
      ChatMessage(
          id: 'm1_7',
          conversationId: 'conv_1',
          senderId: 'me',
          content:
              'Very basic. Bring a good sleeping bag — it\'s cold at 4450m. But the dal bhat is surprisingly good 😄',
          timestamp: _now.subtract(const Duration(hours: 5, minutes: 45)),
          isMe: true,
          status: MessageStatus.read),
      ChatMessage(
          id: 'm1_8',
          conversationId: 'conv_1',
          senderId: 'p1',
          content: 'Crossed Thorong La this morning!! 5416m!! 🏔🎉',
          timestamp: _now.subtract(const Duration(minutes: 30)),
          isMe: false),
      ChatMessage(
          id: 'm1_9',
          conversationId: 'conv_1',
          senderId: 'p1',
          content:
              'The Thorong La pass was brutal yesterday 😅 Glad we made it!',
          timestamp: _now.subtract(const Duration(minutes: 4)),
          isMe: false),
    ],
    'conv_2': [
      ChatMessage(
          id: 'm2_1',
          conversationId: 'conv_2',
          senderId: 'p2',
          content:
              'Hey! I saw your Langtang Valley story — those photos are stunning 😍',
          timestamp: _now.subtract(const Duration(days: 1, hours: 3)),
          isMe: false),
      ChatMessage(
          id: 'm2_2',
          conversationId: 'conv_2',
          senderId: 'me',
          content:
              'Thank you! Shot everything on a Fuji X-T5. The light in the valley at 5pm is magical.',
          timestamp:
              _now.subtract(const Duration(days: 1, hours: 2, minutes: 50)),
          isMe: true,
          status: MessageStatus.read),
      ChatMessage(
          id: 'm2_3',
          conversationId: 'conv_2',
          senderId: 'p2',
          content: 'I\'m planning Langtang for October. Any tips on teahouses?',
          timestamp: _now.subtract(const Duration(days: 1, hours: 2)),
          isMe: false),
      ChatMessage(
          id: 'm2_4',
          conversationId: 'conv_2',
          senderId: 'me',
          content:
              'Yak Lodge in Kyanjin Gompa is the best. Heated common room, great yak cheese! 🧀',
          timestamp:
              _now.subtract(const Duration(days: 1, hours: 1, minutes: 45)),
          isMe: true,
          status: MessageStatus.read),
      ChatMessage(
          id: 'm2_5',
          conversationId: 'conv_2',
          senderId: 'me',
          content: 'Sent you the packing list for the Langtang trek 📋',
          timestamp: _now.subtract(const Duration(hours: 1)),
          isMe: true,
          status: MessageStatus.delivered),
    ],
    'conv_3': [
      ChatMessage(
          id: 'm3_1',
          conversationId: 'conv_3',
          senderId: 'p1',
          content:
              'Welcome everyone to the EBC Squad group! March 2025 — let\'s do this 🏔',
          timestamp: _now.subtract(const Duration(days: 14)),
          isMe: false),
      ChatMessage(
          id: 'm3_2',
          conversationId: 'conv_3',
          senderId: 'p4',
          content: 'So excited! Already booked my Lukla flight ✈️',
          timestamp: _now.subtract(const Duration(days: 14)),
          isMe: false),
      ChatMessage(
          id: 'm3_3',
          conversationId: 'conv_3',
          senderId: 'me',
          content:
              'Same! Flying in on March 8. Let\'s sync up in Thamel the night before departure',
          timestamp: _now.subtract(const Duration(days: 13)),
          isMe: true,
          status: MessageStatus.read),
      ChatMessage(
          id: 'm3_4',
          conversationId: 'conv_3',
          senderId: 'p3',
          content: 'Should we hire a group guide or go independent?',
          timestamp: _now.subtract(const Duration(days: 7)),
          isMe: false),
      ChatMessage(
          id: 'm3_5',
          conversationId: 'conv_3',
          senderId: 'p1',
          content:
              'I know a great guide — Dawa Sherpa. 12 EBC summits. Very trustworthy 💪',
          timestamp: _now.subtract(const Duration(days: 7)),
          isMe: false),
      ChatMessage(
          id: 'm3_6',
          conversationId: 'conv_3',
          senderId: 'me',
          content: 'Dawa sounds perfect. Can you share his contact?',
          timestamp: _now.subtract(const Duration(days: 6)),
          isMe: true,
          status: MessageStatus.read),
      ChatMessage(
          id: 'm3_7',
          conversationId: 'conv_3',
          senderId: 'p3',
          content: 'Josh: Who\'s landing in Kathmandu on March 10?',
          timestamp: _now.subtract(const Duration(hours: 3)),
          isMe: false),
    ],
  };
}
