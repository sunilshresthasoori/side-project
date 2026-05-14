import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../domain/models/story_detail_model.dart';

class CommentsSection extends StatefulWidget {
  final List<StoryComment> comments;
  final ValueChanged<String> onPost;
  final ValueChanged<String> onLike;

  const CommentsSection({
    super.key,
    required this.comments,
    required this.onPost,
    required this.onLike,
  });

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            '${widget.comments.length} Comments',
            style: GoogleFonts.syne(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Write a comment',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.glacierWhite,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  widget.onPost(_controller.text);
                  _controller.clear();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: AppGradients.saffronAccent,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    'Post',
                    style: AppTypography.button(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: widget.comments
                .map((comment) => _CommentCard(
                      comment: comment,
                      onLike: () => widget.onLike(comment.id),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final StoryComment comment;
  final VoidCallback onLike;

  const _CommentCard({required this.comment, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.glacierWhite,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.electricTeal.withAlpha(50),
                width: 1.5,
              ),
            ),
            child: ClipOval(
              child: TrekAssetImage(
                assetPath: comment.authorAvatarPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.authorName,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _timeAgo(comment.date),
                      style: AppTypography.caption(context),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment.text,
                  style: AppTypography.body(context),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onLike,
                      child: Row(
                        children: [
                          Icon(
                            comment.isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 14,
                            color: comment.isLiked
                                ? AppColors.coral
                                : AppColors.textLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            comment.likes.toString(),
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSub,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.reply_rounded,
                          size: 14,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Reply',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSub,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _timeAgo(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inDays >= 1) return '${diff.inDays}d ago';
  if (diff.inHours >= 1) return '${diff.inHours}h ago';
  return '${diff.inMinutes}m ago';
}
