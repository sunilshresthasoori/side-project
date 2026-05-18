// lib/features/chat/presentation/pages/conversations_page.dart
//
// STEP 12 — ConversationsPage
// Shows the full list of conversations with:
// - Search bar, pinned section, regular chats
// - Shimmer loading, empty state, error state
// Navigates to ChatDetailPage on row tap.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../bloc/conversations_bloc.dart';
import '../../domain/models/chat_model.dart';
import '../widgets/conversation_tile.dart';
import 'chat_detail_page.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConversationsBloc()..add(const ConversationsFetchEvent()),
      child: const _ConversationsView(),
    );
  }
}

class _ConversationsView extends StatelessWidget {
  const _ConversationsView();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: AppColors.glacierWhite,
      body: BlocBuilder<ConversationsBloc, ConversationsState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              //  Header
              SliverToBoxAdapter(child: _Header()),

              //  Search bar
              SliverToBoxAdapter(child: _SearchBar()),

              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              //  Body
              switch (state) {
                ConversationsInitial() ||
                ConversationsLoading() =>
                  SliverToBoxAdapter(child: _LoadingList()),
                ConversationsError e =>
                  SliverToBoxAdapter(child: _ErrorView(message: e.message)),
                ConversationsLoaded s when s.filtered.isEmpty =>
                  SliverToBoxAdapter(child: _EmptyState(query: s.searchQuery)),
                ConversationsLoaded s =>
                  _ConversationList(conversations: s.filtered),
              },
            ],
          );
        },
      ),
      // Compose new message FAB
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.saffronAccent,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.button,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Icon(Icons.edit_rounded, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

//  HEADER

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 16, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Messages',
                  style: GoogleFonts.syne(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary)),
              Text('Stay connected on the trail',
                  style: GoogleFonts.dmSans(
                      fontSize: 13, color: AppColors.textSub)),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      boxShadow: AppShadows.card),
                  child: const Icon(Icons.notifications_outlined,
                      size: 20, color: AppColors.slateGray),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                      gradient: AppGradients.tealAccent,
                      borderRadius: BorderRadius.circular(AppRadius.sm)),
                  child: const Icon(Icons.person_add_alt_1_rounded,
                      size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//  SEARCH BAR

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppRadius.full),
          boxShadow: AppShadows.card,
        ),
        child: TextField(
          onChanged: (q) => context
              .read<ConversationsBloc>()
              .add(ConversationsSearchChangedEvent(q)),
          style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Search conversations…',
            hintStyle:
                GoogleFonts.dmSans(fontSize: 14, color: AppColors.textLight),
            prefixIcon: const Icon(Icons.search_rounded,
                size: 20, color: AppColors.glacierBlue),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }
}

//  CONVERSATION LIST

class _ConversationList extends StatelessWidget {
  final List<Conversation> conversations;

  const _ConversationList({required this.conversations});

  @override
  Widget build(BuildContext context) {
    final pinned = conversations.where((c) => c.isPinned).toList();
    final regular = conversations.where((c) => !c.isPinned).toList();

    return SliverList(
      delegate: SliverChildListDelegate([
        // Pinned section
        if (pinned.isNotEmpty) ...[
          _SectionLabel(label: '📌  PINNED'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              children: pinned.asMap().entries.map((e) {
                final isLast = e.key == pinned.length - 1;
                return Column(
                  children: [
                    ConversationTile(
                        conversation: e.value,
                        onTap: () => _open(context, e.value)),
                    if (!isLast)
                      const Divider(
                          height: 1, indent: 84, color: AppColors.divider),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Regular section
        if (regular.isNotEmpty) _SectionLabel(label: 'ALL MESSAGES'),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            children: regular.asMap().entries.map((e) {
              final isLast = e.key == regular.length - 1;
              return Column(
                children: [
                  ConversationTile(
                      conversation: e.value,
                      onTap: () => _open(context, e.value)),
                  if (!isLast)
                    const Divider(
                        height: 1, indent: 84, color: AppColors.divider),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 100),
      ]),
    );
  }

  void _open(BuildContext context, Conversation conv) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ChatDetailPage(conversation: conv),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                  CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
              letterSpacing: 1.2),
        ),
      );
}

//  LOADING

class _LoadingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: Column(
            children: List.generate(
                5,
                (i) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(children: [
                        const ShimmerBox(width: 50, height: 50, radius: 25),
                        const SizedBox(width: 14),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              const ShimmerBox(
                                  width: 140, height: 14, radius: 7),
                              const SizedBox(height: 6),
                              const ShimmerBox(
                                  width: double.infinity,
                                  height: 12,
                                  radius: 6),
                            ])),
                      ]),
                    )),
          ),
        ),
      );
}

//  EMPTY STATE

class _EmptyState extends StatelessWidget {
  final String query;

  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(40),
        child: Column(children: [
          const Text('💬', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            query.isNotEmpty
                ? 'No results for "$query"'
                : 'No conversations yet',
            style: GoogleFonts.syne(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            query.isNotEmpty
                ? 'Try a different name or keyword'
                : 'Connect with other trekkers and start chatting!',
            style: AppTypography.body(context),
            textAlign: TextAlign.center,
          ),
        ]),
      );
}

//  ERROR

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(40),
        child: Column(children: [
          const Icon(Icons.wifi_off_rounded,
              size: 48, color: AppColors.textLight),
          const SizedBox(height: 12),
          Text('Could not load messages',
              style: AppTypography.headline(context)),
          const SizedBox(height: 8),
          Text(message,
              style: AppTypography.body(context), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context
                .read<ConversationsBloc>()
                .add(const ConversationsFetchEvent()),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ]),
      );
}
