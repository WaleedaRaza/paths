import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/spotify_track.dart';

/// Spotify Web API client for fetching user data
class SpotifyApiClient {
  final String accessToken;

  SpotifyApiClient(this.accessToken);

  static const String baseUrl = 'https://api.spotify.com/v1';

  /// Get recently played tracks (last 50)
  Future<List<RecentlyPlayed>> getRecentlyPlayed({int limit = 50}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me/player/recently-played?limit=$limit'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['items'] as List;
      
      return items.map((item) {
        final track = item['track'];
        final artists = track['artists'] as List;
        final album = track['album'];
        
        return RecentlyPlayed(
          trackId: track['id'] as String,
          trackName: track['name'] as String,
          artistName: artists.first['name'] as String,
          artistId: artists.first['id'] as String,
          albumName: album['name'] as String,
          albumId: album['id'] as String,
          genres: [], // Genres come from artist endpoint
          playedAt: DateTime.parse(item['played_at'] as String),
          durationMs: track['duration_ms'] as int,
          context: item['context']?['type'] as String?, // playlist, album, artist, etc.
        );
      }).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Token expired or invalid');
    } else {
      throw Exception('Failed to fetch recently played: ${response.statusCode} ${response.body}');
    }
  }

  /// Get user's top artists
  Future<List<SpotifyArtist>> getTopArtists({
    String timeRange = 'medium_term',
    int limit = 20,
  }) async {
    // time_range: short_term (4 weeks), medium_term (6 months), long_term (years)
    final response = await http.get(
      Uri.parse('$baseUrl/me/top/artists?time_range=$timeRange&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['items'] as List;
      
      return items.map((artist) {
        final genres = (artist['genres'] as List?)?.cast<String>() ?? [];
        final images = artist['images'] as List?;
        final imageUrl = images != null && images.isNotEmpty ? images.first['url'] : null;
        
        return SpotifyArtist(
          id: artist['id'] as String,
          name: artist['name'] as String,
          genres: genres,
          imageUrl: imageUrl as String?,
          popularity: artist['popularity'] as int?,
        );
      }).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Token expired or invalid');
    } else {
      throw Exception('Failed to fetch top artists: ${response.statusCode}');
    }
  }

  /// Get user's top tracks
  Future<List<Map<String, dynamic>>> getTopTracks({
    String timeRange = 'medium_term',
    int limit = 20,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me/top/tracks?time_range=$timeRange&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['items'] as List;
      
      return items.map((track) {
        final artists = track['artists'] as List;
        final album = track['album'];
        final images = album['images'] as List?;
        final imageUrl = images != null && images.isNotEmpty ? images.first['url'] : null;
        
        return {
          'id': track['id'],
          'name': track['name'],
          'artistName': artists.first['name'],
          'artistId': artists.first['id'],
          'albumName': album['name'],
          'albumId': album['id'],
          'imageUrl': imageUrl,
          'durationMs': track['duration_ms'],
          'popularity': track['popularity'],
        };
      }).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Token expired or invalid');
    } else {
      throw Exception('Failed to fetch top tracks: ${response.statusCode}');
    }
  }

  /// Get artist details (for genres)
  Future<SpotifyArtist> getArtist(String artistId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/artists/$artistId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final artist = jsonDecode(response.body);
      final genres = (artist['genres'] as List?)?.cast<String>() ?? [];
      final images = artist['images'] as List?;
      final imageUrl = images != null && images.isNotEmpty ? images.first['url'] : null;
      
      return SpotifyArtist(
        id: artist['id'] as String,
        name: artist['name'] as String,
        genres: genres,
        imageUrl: imageUrl as String?,
        popularity: artist['popularity'] as int?,
      );
    } else {
      throw Exception('Failed to fetch artist: ${response.statusCode}');
    }
  }

  /// Get multiple artists at once (batch request)
  Future<List<SpotifyArtist>> getArtists(List<String> artistIds) async {
    if (artistIds.isEmpty) return [];
    
    final ids = artistIds.take(50).join(','); // Max 50 per request
    final response = await http.get(
      Uri.parse('$baseUrl/artists?ids=$ids'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final artists = data['artists'] as List;
      
      return artists.map((artist) {
        if (artist == null) return null;
        
        final genres = (artist['genres'] as List?)?.cast<String>() ?? [];
        final images = artist['images'] as List?;
        final imageUrl = images != null && images.isNotEmpty ? images.first['url'] : null;
        
        return SpotifyArtist(
          id: artist['id'] as String,
          name: artist['name'] as String,
          genres: genres,
          imageUrl: imageUrl as String?,
          popularity: artist['popularity'] as int?,
        );
      }).whereType<SpotifyArtist>().toList();
    } else {
      throw Exception('Failed to fetch artists: ${response.statusCode}');
    }
  }

  /// Get currently playing track
  Future<Map<String, dynamic>?> getCurrentlyPlaying() async {
    final response = await http.get(
      Uri.parse('$baseUrl/me/player/currently-playing'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['item'] == null) return null;
      
      final track = data['item'];
      final artists = track['artists'] as List;
      final album = track['album'];
      final images = album['images'] as List?;
      final imageUrl = images != null && images.isNotEmpty ? images.first['url'] : null;
      
      return {
        'id': track['id'],
        'name': track['name'],
        'artistName': artists.first['name'],
        'artistId': artists.first['id'],
        'albumName': album['name'],
        'imageUrl': imageUrl,
        'progressMs': data['progress_ms'],
        'durationMs': track['duration_ms'],
        'isPlaying': data['is_playing'],
      };
    } else if (response.statusCode == 204) {
      return null; // Nothing playing
    } else {
      throw Exception('Failed to fetch currently playing: ${response.statusCode}');
    }
  }
}

