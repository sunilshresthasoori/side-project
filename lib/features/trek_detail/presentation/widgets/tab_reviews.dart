import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../domain/models/trek_detail_model.dart';

class TabReviews extends StatelessWidget {
  final RatingSummary summary;
  final List<TrekReview> reviews;

  const TabReviews({super.key, required this.summary, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Big number
                    Column(
                      children: [
                        Text(
                          summary.overall.toStringAsFixed(1),
                          style: GoogleFonts.syne(
                            fontSize: 52,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1,
                          ),
                        ),
                        Row(
                          children: List.generate(
                              5,
                              (i) => Icon(
                                    i < summary.overall.floor()
                                        ? Icons.star_rounded
                                        : (i < summary.overall
                                            ? Icons.star_half_rounded
                                            : Icons.star_border_rounded),
                                    color: AppColors.saffron,
                                    size: 18,
                                  )),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Based on ${summary.totalReviews} reviews',
                          style: AppTypography.caption(context),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    // Bar charts
                    Expanded(
                      child: Column(
                        children: [
                          _RatingBar(
                              label: 'Difficulty',
                              value: summary.difficulty,
                              color: AppColors.coral),
                          const SizedBox(height: 8),
                          _RatingBar(
                              label: 'Scenery',
                              value: summary.scenery,
                              color: AppColors.electricTeal),
                          const SizedBox(height: 8),
                          _RatingBar(
                              label: 'Accommodation',
                              value: summary.accommodation,
                              color: AppColors.glacierBlue),
                          const SizedBox(height: 8),
                          _RatingBar(
                              label: 'Safety',
                              value: summary.safety,
                              color: AppColors.saffron),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Write a review button
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.glacierBlue),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_rounded,
                            color: AppColors.glacierBlue, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Write a Review',
                          style: GoogleFonts.syne(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.glacierBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          //  Individual reviews
          ...reviews.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ReviewCard(review: r),
              )),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

//  RATING BAR

class _RatingBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _RatingBar(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(label,
                style:
                    GoogleFonts.dmSans(fontSize: 11, color: AppColors.textSub)),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                    height: 6,
                    decoration: BoxDecoration(
                        color: AppColors.snowFog,
                        borderRadius: BorderRadius.circular(3))),
                FractionallySizedBox(
                  widthFactor: value / 5,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(3)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value.toStringAsFixed(1),
            style: GoogleFonts.syne(
                fontSize: 11, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      );
}

//  REVIEW CARD

class _ReviewCard extends StatelessWidget {
  final TrekReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Author row
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.electricTeal.withOpacity(0.4), width: 2),
                ),
                child: ClipOval(
                  child: TrekAssetImage(
                      assetPath: review.authorAvatarPath, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.authorName,
                          style: GoogleFonts.syne(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary),
                        ),
                        if (review.isVerified) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2ECC71).withOpacity(0.12),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                              border: Border.all(
                                  color:
                                      const Color(0xFF2ECC71).withOpacity(0.4)),
                            ),
                            child: Text('Verified',
                                style: GoogleFonts.dmSans(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2ECC71))),
                          ),
                        ],
                      ],
                    ),
                    Text(review.timeAgo, style: AppTypography.caption(context)),
                  ],
                ),
              ),
              // Stars
              Row(
                  children: List.generate(
                      5,
                      (i) => Icon(
                            i < review.overallRating.floor()
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: AppColors.saffron,
                            size: 16,
                          ))),
            ],
          ),

          const SizedBox(height: 12),

          //  Sub ratings
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _SubRating('Difficulty', review.difficultyRating),
              _SubRating('Scenery', review.sceneryRating),
              _SubRating('Accomm.', review.accommodationRating),
              _SubRating('Safety', review.safetyRating),
            ],
          ),

          const SizedBox(height: 12),

          //  Review body
          Text(
            review.body,
            style: GoogleFonts.dmSans(
                fontSize: 13, color: AppColors.textSub, height: 1.65),
          ),

          //  Review photos
          if (review.photosPaths.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.photosPaths.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: TrekAssetImage(
                      assetPath: review.photosPaths[i],
                      width: 90,
                      height: 72,
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ],

          const SizedBox(height: 14),

          //  Helpful
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                const Icon(Icons.thumb_up_alt_outlined,
                    size: 15, color: AppColors.textLight),
                const SizedBox(width: 6),
                Text(
                  'Helpful (${review.helpfulCount})',
                  style: AppTypography.caption(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubRating extends StatelessWidget {
  final String label;
  final double value;

  const _SubRating(this.label, this.value);

  @override
  Widget build(BuildContext context) => Text(
        '$label: ${value.toStringAsFixed(0)}/5',
        style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.textLight),
      );
}
