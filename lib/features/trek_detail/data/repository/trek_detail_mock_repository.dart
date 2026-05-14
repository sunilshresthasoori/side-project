import 'dart:async';
import '../../domain/models/trek_detail_model.dart';

class TrekDetailMockRepository {
  Future<TrekDetail> fetchTrekDetail(String trekId) async {
    await Future.delayed(const Duration(milliseconds: 700));

    switch (trekId) {
      case 'everest-base':
        return _everestBaseDetail();
      default:
        return _everestBaseDetail(); // fallback for now
    }
  }

  TrekDetail _everestBaseDetail() {
    return const TrekDetail(
      id: 'everest-base',
      title: 'Everest Base Camp',
      region: 'Khumbu',
      country: 'Nepal',
      galleryImages: [
        'assets/images/trek_everest.jpg',
        'assets/images/hero_bg.jpg',
        'assets/images/cat_high_altitude.jpg',
        'assets/images/cat_glacier.jpg',
      ],
      galleryCaptions: [
        'Mount Everest — The Roof of the World',
        'Khumbu Icefall at dawn',
        'High altitude ridge approaching Base Camp',
        'Glacial blues of the Khumbu region',
      ],
      aboutText:
          'The Everest Base Camp Trek is one of the most iconic trekking routes in the world, offering breathtaking views of the world\'s highest peaks and an immersive experience into Sherpa culture.\n\nThis challenging yet rewarding journey takes you through picturesque Sherpa villages, ancient monasteries, and diverse landscapes ranging from lush forests to high-altitude terrain. Along the way, you\'ll witness spectacular mountain vistas including Everest, Lhotse, Nuptse, and Ama Dablam.\n\nThe trek provides ample opportunities for acclimatization, ensuring a safe and enjoyable experience. The journey culminates at Everest Base Camp (5,364m), where mountaineers prepare for their summit attempts.',
      difficulty: 'Hard',
      durationDays: 14,
      distanceKm: 130,
      maxAltitudeM: 5364,
      bestSeason: 'Mar–May, Sep–Nov',
      priceNPR: 1200,
      ratingSummary: RatingSummary(
        overall: 4.8,
        totalReviews: 156,
        difficulty: 4.3,
        scenery: 5.0,
        accommodation: 3.7,
        safety: 4.7,
      ),

      //  ROUTE POINTS
      routePoints: [
        RoutePoint(
            stepNumber: 1,
            name: 'Lukla',
            altitudeM: 2860,
            description:
                'Gateway to Everest, home to the world\'s most dangerous airport.'),
        RoutePoint(
            stepNumber: 2,
            name: 'Phakding',
            altitudeM: 2610,
            description:
                'Peaceful riverside village, first night acclimatization stop.'),
        RoutePoint(
            stepNumber: 3,
            name: 'Namche Bazaar',
            altitudeM: 3440,
            description:
                'The Sherpa capital — bustling market town at the valley junction.'),
        RoutePoint(
            stepNumber: 4,
            name: 'Tengboche',
            altitudeM: 3860,
            description:
                'Famous monastery with stunning Ama Dablam and Everest views.'),
        RoutePoint(
            stepNumber: 5,
            name: 'Dingboche',
            altitudeM: 4410,
            description:
                'Critical acclimatization stop in the Imja Khola valley.'),
        RoutePoint(
            stepNumber: 6,
            name: 'Lobuche',
            altitudeM: 4910,
            description:
                'Last major settlement before the final push to Base Camp.'),
        RoutePoint(
            stepNumber: 7,
            name: 'Gorak Shep',
            altitudeM: 5164,
            description:
                'The highest teahouse on the route, last sleep before EBC.'),
        RoutePoint(
            stepNumber: 8,
            name: 'Everest Base Camp',
            altitudeM: 5364,
            description:
                'The summit of your journey — the base of the world\'s highest peak.'),
      ],

      //  ITINERARY
      itinerary: [
        ItineraryDay(
          dayNumber: 1,
          title: 'Fly to Lukla, Trek to Phakding',
          subtitle: 'Day 1',
          durationHours: 4,
          distanceKm: 8,
          altitudeM: 2610,
          description:
              'Early morning scenic flight from Kathmandu to Lukla (2,860m). After landing at Tenzing-Hillary Airport, meet your trekking crew and begin the trek. The trail descends through pine forests and follows the Dudh Koshi River valley. Pass through several small villages and cross suspension bridges decorated with prayer flags. Arrive at Phakding, a small village with teahouses and lodges.',
          checkpoints: [
            ItineraryCheckpoint(
                name: 'Lukla',
                description:
                    'Gateway to Everest, home to the world\'s most dangerous airport.',
                altitudeM: 2860,
                tempMin: '5°C',
                tempMax: '10°C',
                hasWifi: true,
                hasAtm: true),
            ItineraryCheckpoint(
                name: 'Phakding',
                description:
                    'Peaceful riverside village, perfect first night acclimatization stop.',
                altitudeM: 2610,
                tempMin: '3°C',
                tempMax: '8°C',
                hasWifi: true),
          ],
        ),
        ItineraryDay(
          dayNumber: 2,
          title: 'Trek to Namche Bazaar',
          subtitle: 'Day 2',
          durationHours: 6,
          distanceKm: 11,
          altitudeM: 3440,
          description:
              'One of the most demanding days of the trek. The trail climbs steeply through rhododendron and pine forests. Cross the famous Hillary Suspension Bridge. If weather permits, you\'ll get your first stunning view of Everest. Namche Bazaar is the bustling Sherpa capital with bakeries, gear shops, and a vibrant weekly market.',
          checkpoints: [
            ItineraryCheckpoint(
                name: 'Hillary Bridge',
                description:
                    'Iconic suspension bridge over the Dudh Koshi river.',
                altitudeM: 2800,
                tempMin: '2°C',
                tempMax: '8°C'),
            ItineraryCheckpoint(
                name: 'Namche Bazaar',
                description:
                    'Sherpa capital — explore the market and bakeries.',
                altitudeM: 3440,
                tempMin: '0°C',
                tempMax: '6°C',
                hasWifi: true,
                hasAtm: true,
                hasCharging: true),
          ],
        ),
        ItineraryDay(
          dayNumber: 3,
          title: 'Acclimatization Day — Namche',
          subtitle: 'Day 3',
          durationHours: 3,
          distanceKm: 5,
          altitudeM: 3440,
          description:
              'Rest day for acclimatization. Take a short hike to Everest View Hotel for panoramic mountain views. Visit the Sherpa Culture Museum and the Hillary School. Evening in Namche with optional bakery visit.',
          checkpoints: [
            ItineraryCheckpoint(
                name: 'Everest View Hotel',
                description:
                    'Best panoramic views of Everest, Lhotse, Ama Dablam.',
                altitudeM: 3880,
                tempMin: '-2°C',
                tempMax: '4°C'),
          ],
        ),
        ItineraryDay(
          dayNumber: 4,
          title: 'Trek to Tengboche Monastery',
          subtitle: 'Day 4',
          durationHours: 5,
          distanceKm: 9,
          altitudeM: 3860,
          description:
              'Trail winds through rhododendron forests with stunning views of Ama Dablam, Thamserku, and Kangtega. Tengboche monastery is the largest in the Khumbu region — witness evening prayer ceremonies.',
          checkpoints: [
            ItineraryCheckpoint(
                name: 'Tengboche',
                description:
                    'Largest monastery in Khumbu, evening prayer ceremony.',
                altitudeM: 3860,
                tempMin: '-3°C',
                tempMax: '4°C',
                hasWifi: true),
          ],
        ),
      ],

      //  HOTELS
      hotels: [
        TrekHotel(
          id: 'h1',
          name: 'Everest Summit Lodge',
          location: 'Namche Bazaar',
          imagePath: 'assets/images/hotel_summit.jpg',
          rating: 4.8,
          priceMinUSD: 40,
          priceMaxUSD: 60,
          amenities: ['Hot Shower', 'WiFi', 'Restaurant', 'Heating', 'ATM'],
          isVerified: true,
        ),
        TrekHotel(
          id: 'h2',
          name: 'Himalayan Teahouse',
          location: 'Tengboche',
          imagePath: 'assets/images/hotel_himalayan.jpg',
          rating: 4.6,
          priceMinUSD: 30,
          priceMaxUSD: 50,
          amenities: ['Hot Shower', 'Restaurant', 'Monastery View', 'Bakery'],
          isVerified: true,
        ),
        TrekHotel(
          id: 'h3',
          name: 'Yak Lodge & Restaurant',
          location: 'Dingboche',
          imagePath: 'assets/images/hotel_yak.jpg',
          rating: 4.5,
          priceMinUSD: 20,
          priceMaxUSD: 35,
          amenities: ['Solar Charging', 'Restaurant', 'Common Room'],
          isVerified: true,
        ),
        TrekHotel(
          id: 'h4',
          name: 'Base Camp Lodge',
          location: 'Gorak Shep',
          imagePath: 'assets/images/hotel_basecamp.jpg',
          rating: 4.3,
          priceMinUSD: 15,
          priceMaxUSD: 25,
          amenities: ['Hot Drinks', 'Basic Meals', 'Yak Blankets'],
          isVerified: false,
        ),
      ],

      //  REVIEWS
      reviews: [
        TrekReview(
          id: 'r1',
          authorName: 'Sarah Johnson',
          authorAvatarPath: 'assets/images/avatar_priya.jpg',
          timeAgo: '2 weeks ago',
          overallRating: 5.0,
          difficultyRating: 4.0,
          sceneryRating: 5.0,
          accommodationRating: 4.0,
          safetyRating: 5.0,
          body:
              'This trek exceeded all my expectations! The views were absolutely breathtaking, and our guide was incredibly knowledgeable about the region and culture. The teahouses were comfortable, and the food was surprisingly good at high altitudes.\n\nThe acclimatization days were crucial and well-planned. Reaching Everest Base Camp was a dream come true. Highly recommend proper preparation and fitness training before attempting this trek.',
          helpfulCount: 24,
          isVerified: true,
          photosPaths: [
            'assets/images/story_thorong.jpg',
            'assets/images/cat_glacier.jpg'
          ],
        ),
        TrekReview(
          id: 'r2',
          authorName: 'Marcus Wren',
          authorAvatarPath: 'assets/images/avatar_josh.jpg',
          timeAgo: '1 month ago',
          overallRating: 4.5,
          difficultyRating: 4.5,
          sceneryRating: 5.0,
          accommodationRating: 3.5,
          safetyRating: 4.5,
          body:
              'Absolute bucket-list tick. The altitude hit me harder than expected at Lobuche — take the acclimatization days seriously, don\'t rush. Namche Bazaar is incredible — the bakery scene alone is worth the climb.',
          helpfulCount: 18,
          isVerified: true,
        ),
      ],

      //  PERMITS
      permits: [
        TrekPermit(
          name: 'Sagarmatha National Park Entry',
          description:
              'Required for entry into Sagarmatha National Park. Can be obtained in Kathmandu or at the park entrance in Monjo.',
          priceNPR: 3000,
          priceUSD: 30,
        ),
        TrekPermit(
          name: 'Khumbu Pasang Lhamu Rural Municipality',
          description:
              'Local area permit required for trekking in the Khumbu region. Available in Lukla or Kathmandu.',
          priceNPR: 2000,
          priceUSD: 20,
        ),
      ],

      //  PACKING LIST
      packingList: [
        PackingCategory(
          title: 'Clothing',
          items: [
            'Thermal base layers (top & bottom)',
            'Fleece jacket or pullover',
            'Down jacket (for high altitude)',
            'Waterproof jacket and pants',
            'Trekking pants (2–3 pairs)',
            'Warm hat and sun hat',
            'Gloves (liner and insulated)',
            'Hiking socks (4–5 pairs)'
          ],
        ),
        PackingCategory(
          title: 'Footwear',
          items: [
            'Waterproof trekking boots',
            'Camp shoes or sandals',
            'Gaiters (optional but recommended)'
          ],
        ),
        PackingCategory(
          title: 'Equipment',
          items: [
            'Sleeping bag (−15°C rated)',
            'Trekking poles',
            'Headlamp with extra batteries',
            'Sunglasses (UV protection)',
            'Water bottles or hydration system',
            'Daypack (25–30L)'
          ],
        ),
        PackingCategory(
          title: 'Personal Items',
          items: [
            'Sunscreen (SPF 50+)',
            'Lip balm with SPF',
            'Personal first aid kit',
            'Toiletries and wet wipes',
            'Quick-dry towel',
            'Camera and extra batteries'
          ],
        ),
      ],
    );
  }
}
