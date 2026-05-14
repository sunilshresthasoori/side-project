
import '../../domain/models/trek_models.dart';

class HomeMockRepository {
  static const String _categoryHighAltitudeUrl =
      'assets/images/cat_high_altitude.jpg';
  static const String _categoryForestUrl = 'assets/images/cat_forest.jpg';
  static const String _categoryGlacierUrl = 'assets/images/cat_glacier.jpg';
  static const String _categoryCultureUrl = 'assets/images/cat_cultural.jpg';
  static const String _everestTrekUrl = 'assets/images/trek_everest.jpg';
  static const String _annapurnaTrekUrl = 'assets/images/trek_annapurna.webp';
  static const String _manasluTrekUrl = 'assets/images/trek_manaslu.png';
  static const String _mustangTrekUrl = 'assets/images/trek_mustang.webp';
  static const String _langtangTrekUrl = 'assets/images/trek_langtang.webp';
  static const String _priyaAvatarUrl = 'assets/images/avatar_priya.jpeg';
  static const String _karmaAvatarUrl = 'assets/images/avatar_khumbu.webp';
  static const String _joshAvatarUrl = 'assets/images/avatar_priya.jpeg';
  static const String _aikoAvatarUrl = 'assets/images/avatar_khumbu.webp';
  static const String _storyThorongUrl = _annapurnaTrekUrl;
  static const String _storyManiRimduUrl = _categoryCultureUrl;
  static const String _storyBudgetUrl = _everestTrekUrl;
  static const String _storyGearUrl = _mustangTrekUrl;

  Future<List<TrekCategory>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const [
      TrekCategory(
        id: 'high-altitude',
        title: 'High Altitude',
        subtitle: '5000m+',
        imagePath: _categoryHighAltitudeUrl,
      ),
      TrekCategory(
        id: 'forest-trails',
        title: 'Forest Trails',
        subtitle: 'Lush & Green',
        imagePath: _categoryForestUrl,
      ),
      TrekCategory(
        id: 'glacier-walks',
        title: 'Glacier Walks',
        subtitle: 'Ice & Snow',
        imagePath: _categoryGlacierUrl,
      ),
      TrekCategory(
        id: 'cultural-routes',
        title: 'Cultural Routes',
        subtitle: 'Heritage & Fest',
        imagePath: _categoryCultureUrl,
      ),
    ];
  }

  Future<List<FeaturedTrek>> fetchFeaturedTrek() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      FeaturedTrek(
        id: 'everest-base',
        title: 'Evere st Base Camp',
        region: 'Khumbu, Nepal',
        imagePath: _everestTrekUrl,
        durationDays: 14,
        altitudeM: 5364,
        priceNpr: 1200,
        rating: 4.9,
        reviewCount: 3241,
        difficulty: 'Hard',
        isFavourite: true,
      ),
      FeaturedTrek(
          id: 'annapurna-circuit',
          title: 'Annapurna Circuit',
          region: 'Gandaki, Nepal',
          imagePath: _annapurnaTrekUrl,
          durationDays: 18,
          altitudeM: 5416,
          priceNpr: 980,
          rating: 4.8,
          reviewCount: 2108,
          difficulty: 'Moderate',
          isFavourite: false),
      FeaturedTrek(
          id: 'manaslu',
          title: 'Manaslu Circuit',
          region: 'Gorkha, Nepal',
          imagePath: _manasluTrekUrl,
          durationDays: 16,
          altitudeM: 5106,
          priceNpr: 1050,
          rating: 4.7,
          reviewCount: 892,
          difficulty: 'Hard',
          isFavourite: true),
      FeaturedTrek(
        id: 'upper-mustang',
        title: 'Upper Mustang',
        region: 'Mustang, Nepal',
        imagePath: _mustangTrekUrl,
        durationDays: 12,
        altitudeM: 3840,
        priceNpr: 1500,
        rating: 4.9,
        reviewCount: 564,
        difficulty: 'Moderate',
        isFavourite: false,
      ),
      FeaturedTrek(
          id: 'langtang',
          title: 'Langtang Valley',
          region: 'Rasuwa, Nepal',
          imagePath: _langtangTrekUrl,
          durationDays: 10,
          altitudeM: 4984,
          priceNpr: 720,
          rating: 4.6,
          reviewCount: 1340,
          difficulty: 'Easy',
          isFavourite: true),
    ];
  }

  Future<List<CommunityStory>> fetchCommunityStories() async {
    await Future.delayed(const Duration(milliseconds: 700));

    return const [
      CommunityStory(
        id: 'story-1',
        title: 'Surviving a Snowstorm at Thorong La',
        excerpt:
            'We hit white-out conditions 300m from the pass. Here\'s what saved us — and what you must pack.',
        authorName: 'Priya S.',
        authorAvatarPath: _priyaAvatarUrl,
        imagePath: _storyThorongUrl,
        timeAgo: '2h ago',
        likes: 4821,
        comments: 213,
        tags: 'Trek Report',
      ),
      CommunityStory(
        id: 'story-2',
        title: 'Mani Rimdu Festival — Trekking Through Living History',
        excerpt:
            'Monks in vivid masks, butter lamps at 3800m, and silence you can feel. This is why we trek.',
        authorName: 'Karma T.',
        authorAvatarPath: _karmaAvatarUrl,
        imagePath: _storyManiRimduUrl,
        timeAgo: '1d ago',
        likes: 7630,
        comments: 389,
        tags: 'Culture',
      ),
      CommunityStory(
        id: 'story-3',
        title: 'Budget EBC: Under Rs.800 All-In',
        excerpt:
            'Teahouses, local daal bhat, and a borrowed sleeping bag — here\'s the honest cost breakdown.',
        authorName: 'Josh M.',
        authorAvatarPath: _joshAvatarUrl,
        imagePath: _storyBudgetUrl,
        timeAgo: '3d ago',
        likes: 5102,
        comments: 447,
        tags: 'Tips',
      ),
      CommunityStory(
        id: 'story-4',
        title: 'The Gear That Didn\'t Let Me Down at -22°C',
        excerpt:
            'Honest gear review from a 3-week Himalayan winter traverse. Some surprises inside.',
        authorName: 'Aiko N.',
        authorAvatarPath: _aikoAvatarUrl,
        imagePath: _storyGearUrl,
        timeAgo: '5d ago',
        likes: 3290,
        comments: 178,
        tags: 'Gear',
      ),
    ];
  }
}
