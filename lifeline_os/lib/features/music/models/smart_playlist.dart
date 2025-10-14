import 'package:freezed_annotation/freezed_annotation.dart';

part 'smart_playlist.freezed.dart';
part 'smart_playlist.g.dart';

enum PlaylistCriteria {
  morning,
  focus,
  discovery,
  windDown,
  workout,
  creative,
  topTracks,
  recentFavorites,
}

@freezed
class SmartPlaylist with _$SmartPlaylist {
  const factory SmartPlaylist({
    required String id,
    required String name,
    required PlaylistCriteria criteria,
    required List<String> trackIds,
    String? description,
    required DateTime lastGenerated,
    required int timesPlayed,
    required bool isActive,
    required DateTime createdAt,
  }) = _SmartPlaylist;

  factory SmartPlaylist.fromJson(Map<String, dynamic> json) =>
      _$SmartPlaylistFromJson(json);
}

@freezed
class MusicInsight with _$MusicInsight {
  const factory MusicInsight({
    required String id,
    required DateTime weekOf,
    required String llmAnalysis,
    required Map<String, dynamic> dataSnapshot,
    required bool hasBeenRead,
    required DateTime createdAt,
  }) = _MusicInsight;

  factory MusicInsight.fromJson(Map<String, dynamic> json) =>
      _$MusicInsightFromJson(json);
}

@freezed
class SpotifyToken with _$SpotifyToken {
  const factory SpotifyToken({
    required String id,
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresIn,
    required DateTime expiresAt,
    required String scope,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SpotifyToken;

  factory SpotifyToken.fromJson(Map<String, dynamic> json) =>
      _$SpotifyTokenFromJson(json);
}

