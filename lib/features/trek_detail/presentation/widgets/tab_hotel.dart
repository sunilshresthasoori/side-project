
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../domain/models/trek_detail_model.dart';

class TabHotels extends StatelessWidget {
  final List<TrekHotel> hotels;
  const TabHotels({super.key, required this.hotels});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.glacierBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColors.glacierBlue.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 15, color: AppColors.glacierBlue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'These accommodations are located along the trek route. Contact them directly for bookings and availability.',
                    style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textSub, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Hotel grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: hotels.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (_, i) => _HotelCard(hotel: hotels[i]),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  final TrekHotel hotel;
  const _HotelCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          SizedBox(
            height: 110,
            child: Stack(
              fit: StackFit.expand,
              children: [
                TrekAssetImage(assetPath: hotel.imagePath, fit: BoxFit.cover),
                Container(
                  decoration: const BoxDecoration(
                    gradient: AppGradients.cardBottom,
                  ),
                ),
                if (hotel.isVerified)
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2ECC71),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_rounded, size: 10, color: Colors.white),
                          const SizedBox(width: 3),
                          Text('Verified', style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.name,
                  style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 10, color: AppColors.coral),
                    const SizedBox(width: 2),
                    Expanded(child: Text(hotel.location, style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.textSub), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${hotel.priceMinUSD}–\$${hotel.priceMaxUSD}/night',
                  style: GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.glacierBlue),
                ),
                const SizedBox(height: 4),
                StarRow(rating: hotel.rating),
                const SizedBox(height: 8),
                // Amenity chips (first 3)
                Wrap(
                  spacing: 3, runSpacing: 3,
                  children: hotel.amenities.take(3).map((a) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.snowFog,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Text(a, style: GoogleFonts.dmSans(fontSize: 8, color: AppColors.textSub)),
                  )).toList()
                    ..addAll(hotel.amenities.length > 3
                        ? [Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.snowFog,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('+${hotel.amenities.length - 3} more', style: GoogleFonts.dmSans(fontSize: 8, color: AppColors.textLight)),
                    )]
                        : []),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Action buttons
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
            child: Row(
              children: [
                Expanded(child: _HotelBtn(label: 'Call',      color: AppColors.slateGray)),
                SizedBox(width: 4),
                Expanded(child: _HotelBtn(label: 'Details',   color: AppColors.saffron, filled: true)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelBtn extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;
  const _HotelBtn({required this.label, required this.color, this.filled = false});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {},
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color),
      ),
      child: Center(
        child: Text(label, style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700, color: filled ? Colors.white : color)),
      ),
    ),
  );
}