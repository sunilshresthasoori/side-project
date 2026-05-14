import 'package:equatable/equatable.dart';

//  ENUMS

enum ExploreView { grid, map }

enum ExploreMood {
  all,
  highAltitude,
  forest,
  glacier,
  cultural,
  offBeat,
  familyFriendly,
  photography,
}

enum ExploreSort { mostPopular, highestRated, shortestFirst, longestFirst }

//  FILTERS

class ExploreFilters extends Equatable {
  final List<String> locations; // e.g. ['Khumbu', 'Mustang']
  final List<String> difficulties; // e.g. ['Hard', 'Moderate']
  final int durationMin;
  final int durationMax;
  final int altitudeMin;
  final int altitudeMax;
  final List<String> seasons; // e.g. ['Spring', 'Autumn']

  const ExploreFilters({
    this.locations = const [],
    this.difficulties = const [],
    this.durationMin = 1,
    this.durationMax = 30,
    this.altitudeMin = 1000,
    this.altitudeMax = 9000,
    this.seasons = const [],
  });

  bool get isEmpty =>
      locations.isEmpty &&
      difficulties.isEmpty &&
      durationMin == 1 &&
      durationMax == 30 &&
      altitudeMin == 1000 &&
      altitudeMax == 9000 &&
      seasons.isEmpty;

  int get activeCount {
    int count = 0;
    if (locations.isNotEmpty) count++;
    if (difficulties.isNotEmpty) count++;
    if (durationMin != 1 || durationMax != 30) count++;
    if (altitudeMin != 1000 || altitudeMax != 9000) count++;
    if (seasons.isNotEmpty) count++;
    return count;
  }

  /// Returns a flat list of human-readable active filter labels + their key
  List<ActiveFilterChip> get activeChips {
    final chips = <ActiveFilterChip>[];
    for (final l in locations) {
      chips.add(ActiveFilterChip(label: l, key: 'loc:$l'));
    }
    for (final d in difficulties) {
      chips.add(ActiveFilterChip(label: d, key: 'dif:$d'));
    }
    for (final s in seasons) {
      chips.add(ActiveFilterChip(label: s, key: 'sea:$s'));
    }
    if (durationMin != 1 || durationMax != 30) {
      chips.add(
          ActiveFilterChip(label: '$durationMin–${durationMax}d', key: 'dur'));
    }
    if (altitudeMin != 1000 || altitudeMax != 9000) {
      chips.add(ActiveFilterChip(
          label: '$altitudeMin–${altitudeMax}m', key: 'alt'));
    }
    return chips;
  }

  ExploreFilters copyWith({
    List<String>? locations,
    List<String>? difficulties,
    int? durationMin,
    int? durationMax,
    int? altitudeMin,
    int? altitudeMax,
    List<String>? seasons,
  }) =>
      ExploreFilters(
        locations: locations ?? this.locations,
        difficulties: difficulties ?? this.difficulties,
        durationMin: durationMin ?? this.durationMin,
        durationMax: durationMax ?? this.durationMax,
        altitudeMin: altitudeMin ?? this.altitudeMin,
        altitudeMax: altitudeMax ?? this.altitudeMax,
        seasons: seasons ?? this.seasons,
      );

  static const ExploreFilters empty = ExploreFilters();

  @override
  List<Object?> get props => [
        locations,
        difficulties,
        durationMin,
        durationMax,
        altitudeMin,
        altitudeMax,
        seasons,
      ];
}

class ActiveFilterChip extends Equatable {
  final String label;
  final String key;

  const ActiveFilterChip({required this.label, required this.key});

  @override
  List<Object?> get props => [key];
}

//  EXPLORE TREK (lighter than TrekDetail)

class ExploreTrek extends Equatable {
  final String id;
  final String title;
  final String region;
  final String country;
  final String imagePath;
  final String difficulty;
  final int durationDays;
  final int maxAltitudeM;
  final double rating;
  final int reviewCount;
  final List<String> highlightTags;
  final List<String> moods; // matches ExploreMood labels
  final String bestSeason;
  final bool isTrending;
  final bool isBookmarked;
  final bool isTrekOfWeek;

  const ExploreTrek({
    required this.id,
    required this.title,
    required this.region,
    required this.country,
    required this.imagePath,
    required this.difficulty,
    required this.durationDays,
    required this.maxAltitudeM,
    required this.rating,
    required this.reviewCount,
    required this.highlightTags,
    required this.moods,
    required this.bestSeason,
    this.isTrending = false,
    this.isBookmarked = false,
    this.isTrekOfWeek = false,
  });

  @override
  List<Object?> get props => [id, isBookmarked];
}

//  RECENTLY VIEWED

class RecentlyViewedTrek extends Equatable {
  final String id;
  final String title;
  final String imagePath;
  final String difficulty;

  const RecentlyViewedTrek({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [id];
}
