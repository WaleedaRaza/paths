import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_track.freezed.dart';
part 'spotify_track.g.dart';

@freezed
class SpotifyTrack with _$SpotifyTrack {
  const factory SpotifyTrack({
    required String id,
    required String trackId,
    required String trackName,
    required String artistName,
    required String artistId,
    required String albumName,
    required String albumId,
    required List<String> genres,
    required DateTime playedAt,
    required int durationMs,
    String? context,
    String? playedDuringTaskId,
    required DateTime createdAt,
  }) = _SpotifyTrack;

  factory SpotifyTrack.fromJson(Map<String, dynamic> json) =>
      _$SpotifyTrackFromJson(json);
}

@freezed
class SpotifyArtist with _$SpotifyArtist {
  const factory SpotifyArtist({
    required String id,
    required String name,
    required List<String> genres,
    String? imageUrl,
    int? popularity,
  }) = _SpotifyArtist;

  factory SpotifyArtist.fromJson(Map<String, dynamic> json) =>
      _$SpotifyArtistFromJson(json);
}

@freezed
class SpotifyAlbum with _$SpotifyAlbum {
  const factory SpotifyAlbum({
    required String id,
    required String name,
    required String artistName,
    String? imageUrl,
    DateTime? releaseDate,
  }) = _SpotifyAlbum;

  factory SpotifyAlbum.fromJson(Map<String, dynamic> json) =>
      _$SpotifyAlbumFromJson(json);
}

@freezed
class RecentlyPlayed with _$RecentlyPlayed {
  const factory RecentlyPlayed({
    required String trackId,
    required String trackName,
    required String artistName,
    required String artistId,
    required String albumName,
    required String albumId,
    required List<String> genres,
    required DateTime playedAt,
    required int durationMs,
    String? context,
  }) = _RecentlyPlayed;

  factory RecentlyPlayed.fromJson(Map<String, dynamic> json) =>
      _$RecentlyPlayedFromJson(json);
}

