// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MusicStatsImpl _$$MusicStatsImplFromJson(Map<String, dynamic> json) =>
    _$MusicStatsImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      period: json['period'] as String,
      topArtists: Map<String, int>.from(json['topArtists'] as Map),
      topTracks: Map<String, int>.from(json['topTracks'] as Map),
      topGenres: Map<String, int>.from(json['topGenres'] as Map),
      totalMinutes: (json['totalMinutes'] as num).toInt(),
      uniqueArtists: (json['uniqueArtists'] as num).toInt(),
      uniqueTracks: (json['uniqueTracks'] as num).toInt(),
      newArtistsDiscovered: (json['newArtistsDiscovered'] as num).toInt(),
      hourlyMinutes: (json['hourlyMinutes'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MusicStatsImplToJson(_$MusicStatsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'period': instance.period,
      'topArtists': instance.topArtists,
      'topTracks': instance.topTracks,
      'topGenres': instance.topGenres,
      'totalMinutes': instance.totalMinutes,
      'uniqueArtists': instance.uniqueArtists,
      'uniqueTracks': instance.uniqueTracks,
      'newArtistsDiscovered': instance.newArtistsDiscovered,
      'hourlyMinutes':
          instance.hourlyMinutes.map((k, e) => MapEntry(k.toString(), e)),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$TopItemImpl _$$TopItemImplFromJson(Map<String, dynamic> json) =>
    _$TopItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      playCount: (json['playCount'] as num).toInt(),
      totalMinutes: (json['totalMinutes'] as num).toInt(),
      imageUrl: json['imageUrl'] as String?,
      subtitle: json['subtitle'] as String?,
    );

Map<String, dynamic> _$$TopItemImplToJson(_$TopItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'playCount': instance.playCount,
      'totalMinutes': instance.totalMinutes,
      'imageUrl': instance.imageUrl,
      'subtitle': instance.subtitle,
    };

_$ListeningPatternImpl _$$ListeningPatternImplFromJson(
        Map<String, dynamic> json) =>
    _$ListeningPatternImpl(
      hourlyMinutes: (json['hourlyMinutes'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
      ),
      dayOfWeekMinutes: Map<String, int>.from(json['dayOfWeekMinutes'] as Map),
      peakHour: (json['peakHour'] as num).toInt(),
      peakDay: json['peakDay'] as String,
      avgDailyMinutes: (json['avgDailyMinutes'] as num).toDouble(),
    );

Map<String, dynamic> _$$ListeningPatternImplToJson(
        _$ListeningPatternImpl instance) =>
    <String, dynamic>{
      'hourlyMinutes':
          instance.hourlyMinutes.map((k, e) => MapEntry(k.toString(), e)),
      'dayOfWeekMinutes': instance.dayOfWeekMinutes,
      'peakHour': instance.peakHour,
      'peakDay': instance.peakDay,
      'avgDailyMinutes': instance.avgDailyMinutes,
    };
