import '../../domain/models/community_model.dart';

class CommunityMockRepository {
  final List<CommunityStory> _stories = [
    CommunityStory(
      id: 'story-aurora-iceland',
      title: 'Chasing the Aurora Above Langjokull',
      excerpt:
          'A midnight push across Icelandic ice, with wind that howled like a wolf and skies that finally cracked into green fire.',
      body:
          'The glacier started whispering before we even clipped in. By the time we reached the first ridge, the wind had learned our names.\n\nEvery step glittered. The ice cracked and settled like a living thing, and the silence between gusts was almost louder than the storm.\n\nWhen the aurora finally arrived, it did not look like a curtain. It looked like a river, slow and luminous, cutting across the dark.',
      authorName: 'Sigrid Voss',
      authorBio: 'Polar guide and cold-light photographer.',
      authorAvatarPath: 'assets/images/avatars/avatar_01.jpg',
      authorFollowers: 12840,
      imagePath: 'assets/images/treks/trek_01.jpg',
      galleryImagePaths: List.generate(
        8,
        (index) => 'assets/images/gallery/gallery_${index + 1}.jpg',
      ),
      contentType: 'Photo Story',
      difficulty: 'Hard',
      trekName: 'Langjokull Glacier Traverse',
      location: 'Iceland',
      date: DateTime(2026, 2, 12),
      readTimeMinutes: 9,
      likes: 1480,
      comments: 62,
      shares: 210,
      isBookmarked: true,
      isFeatured: true,
      tags: ['Glacier', 'Aurora', 'Winter'],
    ),
    CommunityStory(
      id: 'story-inca-mist',
      title: 'Misty Switchbacks on the Inca Trail',
      excerpt:
          'Clouds rolled in fast, and the stone steps turned slick. Here is how we kept moving and dry.',
      body:
          'The morning opened with a soft gray hush. Our boots found the ancient stones without urgency, and the forest held the trail like a secret.\n\nWhen the rain hit, it hit sideways. We leaned into the wind and let the trail guide us, trusting the switchbacks to do their work.\n\nBy the time we reached the first viewpoint, the clouds lifted just enough to show the valley breathing below.',
      authorName: 'Mateo Rojas',
      authorBio: 'Mountain storyteller and trail chef.',
      authorAvatarPath: 'assets/images/avatars/avatar_02.jpg',
      authorFollowers: 8450,
      imagePath: 'assets/images/treks/trek_02.jpg',
      galleryImagePaths: List.generate(
        8,
        (index) => 'assets/images/gallery/gallery_${index + 1}.jpg',
      ),
      contentType: 'Trek Report',
      difficulty: 'Moderate',
      trekName: 'Classic Inca Trail',
      location: 'Peru',
      date: DateTime(2026, 1, 28),
      readTimeMinutes: 7,
      likes: 980,
      comments: 41,
      shares: 126,
      isBookmarked: false,
      isFeatured: false,
      tags: const ['Rain', 'Stone Steps', 'Cloud Forest'],
    ),
    CommunityStory(
      id: 'story-sahara-gear',
      title: 'Gear Check: Desert Nights in the Sahara',
      excerpt:
          'The sun drops hard out here. A quick guide to the layers and tools that saved our sleep.',
      body:
          'Heat is only half the desert story. When the sun falls, the sand turns cold and the wind becomes sharp.\n\nWe relied on a tight system: a breathable base, an insulated shell, and a sleeping pad built for heat loss.\n\nThe smallest upgrades made the biggest difference, especially the stove that lit even when the gas chilled.',
      authorName: 'Amira Solane',
      authorBio: 'Gear tester and desert minimalist.',
      authorAvatarPath: 'assets/images/avatars/avatar_03.jpg',
      authorFollowers: 10120,
      imagePath: 'assets/images/treks/trek_03.jpg',
      galleryImagePaths: List.generate(
        8,
        (index) => 'assets/images/gallery/gallery_${index + 1}.jpg',
      ),
      contentType: 'Gear',
      difficulty: 'Easy',
      trekName: 'Erg Chebbi Dunes',
      location: 'Morocco',
      date: DateTime(2026, 3, 6),
      readTimeMinutes: 6,
      likes: 640,
      comments: 19,
      shares: 82,
      isBookmarked: false,
      isFeatured: false,
      tags: ['Desert', 'Layers', 'Camp'],
    ),
    CommunityStory(
      id: 'story-himalaya-safety',
      title: 'Safety Update: New Snow Bridges in Khumbu',
      excerpt:
          'Fresh snow has formed over crevasses near the lower icefall. Here is what to expect and how to cross.',
      body:
          'The lower icefall has changed. Snow bridges have formed where ice was previously exposed, and that means different risks.\n\nWe traveled early to take advantage of frozen conditions and moved with longer spacing than usual.\n\nIf you are heading up, coordinate with your guide team and take a slower line through the central flow.',
      authorName: 'Tenzin K',
      authorBio: 'High-altitude guide based in Lukla.',
      authorAvatarPath: 'assets/images/avatars/avatar_04.jpg',
      authorFollowers: 19450,
      imagePath: 'assets/images/treks/trek_04.jpg',
      galleryImagePaths: List.generate(
        8,
        (index) => 'assets/images/gallery/gallery_${index + 1}.jpg',
      ),
      contentType: 'Safety Update',
      difficulty: 'Extreme',
      trekName: 'Khumbu Icefall Route',
      location: 'Nepal',
      date: DateTime(2026, 2, 2),
      readTimeMinutes: 5,
      likes: 1800,
      comments: 95,
      shares: 320,
      isBookmarked: true,
      isFeatured: false,
      tags: ['Safety', 'Icefall', 'Expedition'],
    ),
    CommunityStory(
      id: 'story-alps-culture',
      title: 'Culture Notes from the Alpine Huts',
      excerpt:
          'A small etiquette guide for sharing meals, bunks, and sunrise stories in the Alps.',
      body:
          'Alpine huts run on rhythm. You eat when the bell rings and you sleep when the lights go out.\n\nA few small gestures go a long way: clean boots outside, share the bench, and keep your pack tight.\n\nBy morning, strangers become trail allies, and the hut feels like a small village above the clouds.',
      authorName: 'Elise Marlow',
      authorBio: 'Cultural traveler with a focus on mountain life.',
      authorAvatarPath: 'assets/images/avatars/avatar_05.jpg',
      authorFollowers: 7020,
      imagePath: 'assets/images/treks/trek_05.jpg',
      galleryImagePaths: List.generate(
        8,
        (index) => 'assets/images/gallery/gallery_${index + 1}.jpg',
      ),
      contentType: 'Culture',
      difficulty: 'Moderate',
      trekName: 'Tour du Mont Blanc',
      location: 'France',
      date: DateTime(2026, 1, 10),
      readTimeMinutes: 8,
      likes: 520,
      comments: 22,
      shares: 64,
      isBookmarked: false,
      isFeatured: false,
      tags: ['Huts', 'Etiquette', 'Tradition'],
    ),
    CommunityStory(
      id: 'story-patagonia-tips',
      title: 'Travel Tips: Fast Weather in Patagonia',
      excerpt:
          'Five habits that kept our crew dry and moving when the wind turned in minutes.',
      body:
          'Patagonia does not ask permission. It sends the wind as a reminder.\n\nWe packed a tight system: dry bags, fast layers, and a constant check on the horizon.\n\nThe best tip was the simplest: stop early before the gusts force you to stop later.',
      authorName: 'Noah Kline',
      authorBio: 'Trail runner and long-haul planner.',
      authorAvatarPath: 'assets/images/avatars/avatar_06.jpg',
      authorFollowers: 5630,
      imagePath: 'assets/images/treks/trek_06.jpg',
      galleryImagePaths: List.generate(
        8,
        (index) => 'assets/images/gallery/gallery_${index + 1}.jpg',
      ),
      contentType: 'Travel Tips',
      difficulty: 'Hard',
      trekName: 'Torres del Paine O Circuit',
      location: 'Chile',
      date: DateTime(2026, 3, 18),
      readTimeMinutes: 6,
      likes: 790,
      comments: 37,
      shares: 98,
      isBookmarked: false,
      isFeatured: false,
      tags: ['Wind', 'Logistics', 'Layers'],
    ),
    CommunityStory(
      id: 'story-dolomites-tips',
      title: 'Tips: Ridge Walking in the Dolomites',
      excerpt:
          'Quick pacing and hydration cues that kept us steady above the tree line.',
      body:
          'Ridges are beautiful and unforgiving. We kept a pace that let us stay ahead of the clouds without burning the group.\n\nWater was the real limiter. Short sips every twenty minutes kept the legs steady, even when the sun slipped behind the peaks.\n\nWhen the wind picked up, we dropped to the lee side and used the rock as cover for a quick reset.',
      authorName: 'Giulia Berni',
      authorBio: 'Alpine guide and trail medic.',
      authorAvatarPath: 'assets/images/avatars/avatar_07.jpg',
      authorFollowers: 11200,
      imagePath: 'assets/images/treks/trek_02.jpg',
      galleryImagePaths: List.generate(
        8,
        (index) => 'assets/images/gallery/gallery_${index + 1}.jpg',
      ),
      contentType: 'Tips',
      difficulty: 'Moderate',
      trekName: 'Alta Via 1',
      location: 'Italy',
      date: DateTime(2026, 3, 2),
      readTimeMinutes: 5,
      likes: 860,
      comments: 33,
      shares: 140,
      isBookmarked: false,
      isFeatured: false,
      tags: ['Ridge', 'Hydration', 'Pacing'],
    ),
    CommunityStory(
      id: 'story-rockies-trail',
      title: 'Trail Condition: Late Snow on Skyline',
      excerpt:
          'Drifts lingered in shaded bowls. Here is the safer line and current turnbacks.',
      body:
          'Late season snow is still holding in the north-facing bowls. We found the safest route by sticking to the exposed rock ribs.\n\nTurnbacks are currently advised past the third ridge due to soft bridges. If you go, move early and carry spikes.\n\nConditions change fast in the afternoons, so plan to be on the descent by noon.',
      authorName: 'Riley West',
      authorBio: 'Park ranger and trail conditions lead.',
      authorAvatarPath: 'assets/images/avatars/avatar_08.jpg',
      authorFollowers: 9500,
      imagePath: 'assets/images/treks/trek_04.jpg',
      galleryImagePaths: List.generate(
        8,
        (index) => 'assets/images/gallery/gallery_${index + 1}.jpg',
      ),
      contentType: 'Trail Condition',
      difficulty: 'Hard',
      trekName: 'Jasper Skyline Trail',
      location: 'Canada',
      date: DateTime(2026, 2, 20),
      readTimeMinutes: 6,
      likes: 720,
      comments: 29,
      shares: 110,
      isBookmarked: true,
      isFeatured: false,
      tags: ['Snow', 'Conditions', 'Route'],
    ),
  ];

  Future<List<CommunityStory>> fetchStories() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return List<CommunityStory>.from(_stories);
  }

  List<String> getLocations() {
    final locations = _stories.map((story) => story.location).toSet().toList();
    locations.sort();
    return locations;
  }

  List<String> getDifficulties() {
    final difficulties =
        _stories.map((story) => story.difficulty).toSet().toList();
    difficulties.sort();
    return difficulties;
  }

  List<String> getContentTypes() {
    final types = _stories.map((story) => story.contentType).toSet().toList();
    types.sort();
    return types;
  }
}
