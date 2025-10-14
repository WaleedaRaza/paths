// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SmartPlaylistImpl _$$SmartPlaylistImplFromJson(Map<String, dynamic> json) =>
    _$SmartPlaylistImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      criteria: $enumDecode(_$PlaylistCriteriaEnumMap, json['criteria']),
      trackIds:
          (json['trackIds'] as List<dynamic>).map((e) => e as String).toList(),
      description: json['description'] as String?,
      lastGenerated: DateTime.parse(json['lastGenerated'] as String),
      timesPlayed: (json['timesPlayed'] as num).toInt(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SmartPlaylistImplToJson(_$SmartPlaylistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'criteria': _$PlaylistCriteriaEnumMap[instance.criteria]!,
      'trackIds': instance.trackIds,
      'description': instance.description,
      'lastGenerated': instance.lastGenerated.toIso8601String(),
      'timesPlayed': instance.timesPlayed,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$PlaylistCriteriaEnumMap = {
  PlaylistCriteria.morning: 'morning',
  PlaylistCriteria.focus: 'focus',
  PlaylistCriteria.discovery: 'discovery',
  PlaylistCriteria.windDown: 'windDown',
  PlaylistCriteria.workout: 'workout',
  PlaylistCriteria.creative: 'creative',
  PlaylistCriteria.topTracks: 'topTracks',
  PlaylistCriteria.recentFavorites: 'recentFavorites',
};

_$MusicInsightImpl _$$MusicInsightImplFromJson(Map<String, dynamic> json) =>
    _$MusicInsightImpl(
      id: json['id'] as String,
      weekOf: DateTime.parse(json['weekOf'] as String),
      llmAnalysis: json['llmAnalysis'] as String,
      dataSnapshot: json['dataSnapshot'] as Map<String, dynamic>,
      hasBeenRead: json['hasBeenRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MusicInsightImplToJson(_$MusicInsightImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weekOf': instance.weekOf.toIso8601String(),
      'llmAnalysis': instance.llmAnalysis,
      'dataSnapshot': instance.dataSnapshot,
      'hasBeenRead': instance.hasBeenRead,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$SpotifyTokenImpl _$$SpotifyTokenImplFromJson(Map<String, dynamic> json) =>
    _$SpotifyTokenImpl(
      id: json['id'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String,
      expiresIn: (json['expiresIn'] as num).toInt(),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      scope: json['scope'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SpotifyTokenImplToJson(_$SpotifyTokenImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
      'expiresIn': instance.expiresIn,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'scope': instance.scope,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
