import 'package:flutter/material.dart';

class GameFilters {
  final Set<String> genres;
  final Set<String> platforms;
  final RangeValues? ratingRange;
  final DateTimeRange? dateStartedRange;
  final DateTimeRange? dateFinishedRange;

  const GameFilters({
    this.genres = const {},
    this.platforms = const {},
    this.ratingRange,
    this.dateStartedRange,
    this.dateFinishedRange,
  });

  bool get isEmpty =>
      genres.isEmpty &&
      platforms.isEmpty &&
      ratingRange == null &&
      dateStartedRange == null &&
      dateFinishedRange == null;

  int get activeCount {
    var count = 0;
    if (genres.isNotEmpty) count++;
    if (platforms.isNotEmpty) count++;
    if (ratingRange != null) count++;
    if (dateStartedRange != null) count++;
    if (dateFinishedRange != null) count++;
    return count;
  }

  GameFilters copyWith({
    Set<String>? genres,
    Set<String>? platforms,
    RangeValues? ratingRange,
    bool clearRatingRange = false,
    DateTimeRange? dateStartedRange,
    bool clearDateStartedRange = false,
    DateTimeRange? dateFinishedRange,
    bool clearDateFinishedRange = false,
  }) {
    return GameFilters(
      genres: genres ?? this.genres,
      platforms: platforms ?? this.platforms,
      ratingRange: clearRatingRange ? null : (ratingRange ?? this.ratingRange),
      dateStartedRange:
          clearDateStartedRange ? null : (dateStartedRange ?? this.dateStartedRange),
      dateFinishedRange:
          clearDateFinishedRange ? null : (dateFinishedRange ?? this.dateFinishedRange),
    );
  }
}
