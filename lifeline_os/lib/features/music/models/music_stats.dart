import 'package:freezed_annotation/freezed_annotation.dart';

part 'music_stats.freezed.dart';
part 'music_stats.g.dart';

@freezed
class MusicStats with _$MusicStats {
  const factory MusicStats({
    required String id,
    required DateTime date,
    required String period, // 'day', 'week', 'month', 'year'
    required Map<String, int> topArtists,
    required Map<String, int> topTracks,
    required Map<String, int> topGenres,
    required int totalMinutes,
    required int uniqueArtists,
    required int uniqueTracks,
    required int newArtistsDiscovered,
    required Map<int, int> hourlyMinutes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MusicStats;

  factory MusicStats.fromJson(Map<String, dynamic> json) =>
      _$MusicStatsFromJson(json);
}

@freezed
class TopItem with _$TopItem {
  const factory TopItem({
    required String id,
    required String name,
    required int playCount,
    required int totalMinutes,
    String? imageUrl,
    String? subtitle, // Artist name for tracks, genres for artists
  }) = _TopItem;

  factory TopItem.fromJson(Map<String, dynamic> json) =>
      _$TopItemFromJson(json);
}

@freezed
class ListeningPattern with _$ListeningPattern {
  const factory ListeningPattern({
    required Map<int, int> hourlyMinutes, // hour -> minutes
    required Map<String, int> dayOfWeekMinutes, // day -> minutes
    required int peakHour,
    required String peakDay,
    required double avgDailyMinutes,
  }) = _ListeningPattern;

  factory ListeningPattern.fromJson(Map<String, dynamic> json) =>
      _$ListeningPatternFromJson(json);
}

