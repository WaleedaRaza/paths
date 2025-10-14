// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpotifyTrackImpl _$$SpotifyTrackImplFromJson(Map<String, dynamic> json) =>
    _$SpotifyTrackImpl(
      id: json['id'] as String,
      trackId: json['trackId'] as String,
      trackName: json['trackName'] as String,
      artistName: json['artistName'] as String,
      artistId: json['artistId'] as String,
      albumName: json['albumName'] as String,
      albumId: json['albumId'] as String,
      genres:
          (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
      playedAt: DateTime.parse(json['playedAt'] as String),
      durationMs: (json['durationMs'] as num).toInt(),
      context: json['context'] as String?,
      playedDuringTaskId: json['playedDuringTaskId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SpotifyTrackImplToJson(_$SpotifyTrackImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trackId': instance.trackId,
      'trackName': instance.trackName,
      'artistName': instance.artistName,
      'artistId': instance.artistId,
      'albumName': instance.albumName,
      'albumId': instance.albumId,
      'genres': instance.genres,
      'playedAt': instance.playedAt.toIso8601String(),
      'durationMs': instance.durationMs,
      'context': instance.context,
      'playedDuringTaskId': instance.playedDuringTaskId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$SpotifyArtistImpl _$$SpotifyArtistImplFromJson(Map<String, dynamic> json) =>
    _$SpotifyArtistImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      genres:
          (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
      imageUrl: json['imageUrl'] as String?,
      popularity: (json['popularity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SpotifyArtistImplToJson(_$SpotifyArtistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'genres': instance.genres,
      'imageUrl': instance.imageUrl,
      'popularity': instance.popularity,
    };

_$SpotifyAlbumImpl _$$SpotifyAlbumImplFromJson(Map<String, dynamic> json) =>
    _$SpotifyAlbumImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      artistName: json['artistName'] as String,
      imageUrl: json['imageUrl'] as String?,
      releaseDate: json['releaseDate'] == null
          ? null
          : DateTime.parse(json['releaseDate'] as String),
    );

Map<String, dynamic> _$$SpotifyAlbumImplToJson(_$SpotifyAlbumImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'artistName': instance.artistName,
      'imageUrl': instance.imageUrl,
      'releaseDate': instance.releaseDate?.toIso8601String(),
    };

_$RecentlyPlayedImpl _$$RecentlyPlayedImplFromJson(Map<String, dynamic> json) =>
    _$RecentlyPlayedImpl(
      trackId: json['trackId'] as String,
      trackName: json['trackName'] as String,
      artistName: json['artistName'] as String,
      artistId: json['artistId'] as String,
      albumName: json['albumName'] as String,
      albumId: json['albumId'] as String,
      genres:
          (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
      playedAt: DateTime.parse(json['playedAt'] as String),
      durationMs: (json['durationMs'] as num).toInt(),
      context: json['context'] as String?,
    );

Map<String, dynamic> _$$RecentlyPlayedImplToJson(
        _$RecentlyPlayedImpl instance) =>
    <String, dynamic>{
      'trackId': instance.trackId,
      'trackName': instance.trackName,
      'artistName': instance.artistName,
      'artistId': instance.artistId,
      'albumName': instance.albumName,
      'albumId': instance.albumId,
      'genres': instance.genres,
      'playedAt': instance.playedAt.toIso8601String(),
      'durationMs': instance.durationMs,
      'context': instance.context,
    };
