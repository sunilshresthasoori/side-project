import 'package:flutter/material.dart';
import '../../features/chat/domain/model/chat.dart';
import '../../features/chat/presentation/pages/chat_detail_page.dart';
import '../../features/chat/presentation/pages/conversation_page.dart';
import '../../features/community/presentation/pages/community_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/story_detail/presentation/pages/story_detail_page.dart';
import '../../features/trek_detail/presentation/pages/trek_detail_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String explore = '/explore';
  static const String trekDetail = '/trek-detail';
  static const String community = '/community';
  static const String storyDetail = '/story-detail';
  static const String profile = '/profile';
  static const String conversations = '/conversations';
  static const String chatDetail = '/chat-detail';

  static void pushTrekDetail(BuildContext context, {required String trekId}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => TrekDetailPage(trekId: trekId),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 320),
      ),
    );
  }

  static void pushExplore(BuildContext context, {String? mood}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ExplorePage(initialMood: mood),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                  CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 320),
      ),
    );
  }

  static void pushStoryDetail(BuildContext context, {required String storyId}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => StoryDetailPage(storyId: storyId),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 320),
      ),
    );
  }

  static void pushConversations(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const ConversationsPage(),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 320),
      ),
    );
  }

  static void pushChatDetail(BuildContext context,
      {required Conversation conversation}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ChatDetailPage(conversation: conversation),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 320),
      ),
    );
  }
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return _fade(const HomePage());
      case AppRoutes.conversations:
        return _slide(const ConversationsPage());
      case AppRoutes.chatDetail:
        final args = settings.arguments;
        Conversation? conversation;
        if (args is Conversation) {
          conversation = args;
        } else if (args is Map) {
          final maybe = args['conversation'];
          if (maybe is Conversation) conversation = maybe;
        }

        if (conversation == null) {
          return _slide(const ConversationsPage());
        }

        return _slide(ChatDetailPage(conversation: conversation));
      case AppRoutes.community:
        return _fade(const CommunityPage());
      case AppRoutes.profile:
        return _fade(const ProfilePage());
      case AppRoutes.trekDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final trekId = args?['trekId'] as String? ?? 'everest-base';
        return _slide(TrekDetailPage(trekId: trekId));
      case AppRoutes.storyDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final storyId = args?['storyId'] as String? ?? 'story-aurora-iceland';
        return _slide(StoryDetailPage(storyId: storyId));
      default:
        return _fade(const HomePage());
    }
  }

  static PageRouteBuilder _fade(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 280),
      );

  static PageRouteBuilder _slide(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 320),
      );
}
