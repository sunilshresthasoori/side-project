import '../../domain/models/story_detail_model.dart';

class StoryDetailMockRepository {
  final List<StoryDetail> _stories = List.generate(8, (index) {
    final imageIndex = (index % 6) + 1;
    return StoryDetail(
      id: _storyIds[index],
      title: _storyTitles[index],
      excerpt: _storyExcerpts[index],
      sections: _sectionsFor(index),
      authorName: _authorNames[index],
      authorBio: _authorBios[index],
      authorAvatarPath: 'assets/images/avatars/avatar_0${imageIndex}.jpg',
      authorFollowers: _authorFollowers[index],
      imagePath: 'assets/images/treks/trek_0${imageIndex}.jpg',
      galleryImagePaths: List.generate(
        8,
        (i) => 'assets/images/gallery/gallery_${i + 1}.jpg',
      ),
      contentType: _contentTypes[index],
      difficulty: _difficulties[index],
      trekName: _trekNames[index],
      location: _locations[index],
      date: _dates[index],
      readTimeMinutes: _readTimes[index],
      likes: _likes[index],
      comments: 3,
      shares: _shares[index],
      isBookmarked: index % 2 == 0,
      tags: _tags[index],
      commentList: _commentsFor(index),
      relatedStories: _relatedStoriesFor(index),
    );
  });

  Future<StoryDetail> fetchStoryDetail(String storyId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _stories.firstWhere((story) => story.id == storyId);
  }
}

const List<String> _storyIds = [
  'story-aurora-iceland',
  'story-inca-mist',
  'story-sahara-gear',
  'story-himalaya-safety',
  'story-alps-culture',
  'story-patagonia-tips',
  'story-dolomites-tips',
  'story-rockies-trail',
];

const List<String> _storyTitles = [
  'Chasing the Aurora Above Langjokull',
  'Misty Switchbacks on the Inca Trail',
  'Gear Check: Desert Nights in the Sahara',
  'Safety Update: New Snow Bridges in Khumbu',
  'Culture Notes from the Alpine Huts',
  'Travel Tips: Fast Weather in Patagonia',
  'Tips: Ridge Walking in the Dolomites',
  'Trail Condition: Late Snow on Skyline',
];

const List<String> _storyExcerpts = [
  'A midnight push across Icelandic ice, with wind that howled like a wolf and skies that finally cracked into green fire.',
  'Clouds rolled in fast, and the stone steps turned slick. Here is how we kept moving and dry.',
  'The sun drops hard out here. A quick guide to the layers and tools that saved our sleep.',
  'Fresh snow has formed over crevasses near the lower icefall. Here is what to expect and how to cross.',
  'A small etiquette guide for sharing meals, bunks, and sunrise stories in the Alps.',
  'Five habits that kept our crew dry and moving when the wind turned in minutes.',
  'Quick pacing and hydration cues that kept us steady above the tree line.',
  'Drifts lingered in shaded bowls. Here is the safer line and current turnbacks.',
];

const List<String> _authorNames = [
  'Sigrid Voss',
  'Mateo Rojas',
  'Amira Solane',
  'Tenzin K',
  'Elise Marlow',
  'Noah Kline',
  'Giulia Berni',
  'Riley West',
];

const List<String> _authorBios = [
  'Polar guide and cold-light photographer.',
  'Mountain storyteller and trail chef.',
  'Gear tester and desert minimalist.',
  'High-altitude guide based in Lukla.',
  'Cultural traveler with a focus on mountain life.',
  'Trail runner and long-haul planner.',
  'Alpine guide and trail medic.',
  'Park ranger and trail conditions lead.',
];

const List<int> _authorFollowers = [
  12840,
  8450,
  10120,
  19450,
  7020,
  5630,
  11200,
  9500,
];

const List<String> _contentTypes = [
  'Photo Story',
  'Trek Report',
  'Gear',
  'Safety Update',
  'Culture',
  'Travel Tips',
  'Tips',
  'Trail Condition',
];

const List<String> _difficulties = [
  'Hard',
  'Moderate',
  'Easy',
  'Extreme',
  'Moderate',
  'Hard',
  'Moderate',
  'Hard',
];

const List<String> _trekNames = [
  'Langjokull Glacier Traverse',
  'Classic Inca Trail',
  'Erg Chebbi Dunes',
  'Khumbu Icefall Route',
  'Tour du Mont Blanc',
  'Torres del Paine O Circuit',
  'Alta Via 1',
  'Jasper Skyline Trail',
];

const List<String> _locations = [
  'Iceland',
  'Peru',
  'Morocco',
  'Nepal',
  'France',
  'Chile',
  'Italy',
  'Canada',
];

final List<DateTime> _dates = [
  DateTime(2026, 2, 12),
  DateTime(2026, 1, 28),
  DateTime(2026, 3, 6),
  DateTime(2026, 2, 2),
  DateTime(2026, 1, 10),
  DateTime(2026, 3, 18),
  DateTime(2026, 3, 2),
  DateTime(2026, 2, 20),
];

const List<int> _readTimes = [9, 7, 6, 5, 8, 6, 5, 6];
const List<int> _likes = [1480, 980, 640, 1800, 520, 790, 860, 720];
const List<int> _shares = [210, 126, 82, 320, 64, 98, 140, 110];

final List<List<String>> _tags = [
  ['Glacier', 'Aurora', 'Winter'],
  ['Rain', 'Stone Steps', 'Cloud Forest'],
  ['Desert', 'Layers', 'Camp'],
  ['Safety', 'Icefall', 'Expedition'],
  ['Huts', 'Etiquette', 'Tradition'],
  ['Wind', 'Logistics', 'Layers'],
  ['Ridge', 'Hydration', 'Pacing'],
  ['Snow', 'Conditions', 'Route'],
];

List<StorySection> _sectionsFor(int index) {
  return [
    StorySection(
      heading: 'The First Push',
      paragraphs: [
        'We started before dawn, headlamps cutting thin lines through the mist. The trail felt quiet, but the cold was already working its way into the gloves.',
        'By the second ridge, the terrain opened up. We moved slower to keep the group tight and the pace even, letting the landscape stretch out around us.',
      ],
    ),
    StorySection(
      heading: 'Weather Turns',
      paragraphs: [
        'The wind arrived without warning. It bent the grasses flat and turned every exposed edge into a whistle. Layers mattered more than speed in this stretch.',
        'We dropped the pace, rechecked straps, and leaned into the rhythm of breath and boots.',
      ],
    ),
    StorySection(
      heading: 'A Clear Window',
      paragraphs: [
        'Just when we were ready to call it, the clouds lifted. The valley opened like a stage, and the entire day felt worth the weight.',
        'We rested there longer than planned, letting the moment settle before the descent.',
      ],
    ),
  ];
}

List<StoryComment> _commentsFor(int index) {
  return [
    StoryComment(
      id: 'c${index + 1}a',
      authorName: 'Kiran Patel',
      authorAvatarPath: 'assets/images/avatars/avatar_07.jpg',
      text: 'This was beautifully written. That wind detail took me right back to my last winter trek.',
      date: DateTime(2026, 3, 20),
      likes: 12,
      isLiked: false,
    ),
    StoryComment(
      id: 'c${index + 1}b',
      authorName: 'Lena Moore',
      authorAvatarPath: 'assets/images/avatars/avatar_08.jpg',
      text: 'Saving this for our next route plan. Thanks for the gear callouts.',
      date: DateTime(2026, 3, 19),
      likes: 7,
      isLiked: true,
    ),
    StoryComment(
      id: 'c${index + 1}c',
      authorName: 'Omar Reyes',
      authorAvatarPath: 'assets/images/avatars/avatar_09.jpg',
      text: 'The section about pacing was spot on. Slow is smooth, smooth is fast.',
      date: DateTime(2026, 3, 18),
      likes: 5,
      isLiked: false,
    ),
  ];
}

List<RelatedStory> _relatedStoriesFor(int index) {
  final base = index % 4;
  return [
    RelatedStory(
      id: _storyIds[base],
      title: _storyTitles[base],
      imagePath: 'assets/images/treks/trek_0${base + 1}.jpg',
      date: _dates[base],
      readTimeMinutes: _readTimes[base],
    ),
    RelatedStory(
      id: _storyIds[(base + 2) % _storyIds.length],
      title: _storyTitles[(base + 2) % _storyTitles.length],
      imagePath: 'assets/images/treks/trek_0${(base + 2) % 6 + 1}.jpg',
      date: _dates[(base + 2) % _dates.length],
      readTimeMinutes: _readTimes[(base + 2) % _readTimes.length],
    ),
  ];
}
