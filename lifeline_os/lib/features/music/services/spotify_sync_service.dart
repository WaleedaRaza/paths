import '../../../core/database/database.dart';
import '../repositories/music_repository.dart';
import 'spotify_api_client.dart';
import 'spotify_auth_service.dart';

/// Service for syncing Spotify listening history
class SpotifySyncService {
  final AppDatabase _db;
  final String clientId;
  final String clientSecret;

  SpotifySyncService(this._db, this.clientId, this.clientSecret);

  /// Sync recent listening history from Spotify
  Future<int> syncRecentPlays() async {
    // Get access token
    final authService = SpotifyAuthService(_db);
    final accessToken = await authService.getAccessToken(clientId, clientSecret);
    
    if (accessToken == null) {
      throw Exception('Not authenticated with Spotify');
    }

    // Fetch recently played from Spotify
    final apiClient = SpotifyApiClient(accessToken);
    final recentTracks = await apiClient.getRecentlyPlayed(limit: 50);

    if (recentTracks.isEmpty) {
      return 0; // No new tracks
    }

    // Get unique artist IDs to fetch genres
    final artistIds = recentTracks.map((t) => t.artistId).toSet().toList();
    final artists = await apiClient.getArtists(artistIds);
    
    // Create artist genre map
    final artistGenres = <String, List<String>>{};
    for (final artist in artists) {
      artistGenres[artist.id] = artist.genres;
    }

    // Save each track with enriched data
    final repo = MusicRepository(_db);
    int newCount = 0;

    for (final track in recentTracks) {
      // Enrich with genres from artist data
      final enrichedTrack = track.copyWith(
        genres: artistGenres[track.artistId] ?? [],
      );
      
      await repo.saveListeningEvent(enrichedTrack);
      newCount++;
    }

    return newCount;
  }

  /// Sync and return status message
  Future<String> syncWithStatus() async {
    try {
      final count = await syncRecentPlays();
      if (count == 0) {
        return 'Already up to date';
      }
      return 'Synced $count new tracks';
    } catch (e) {
      return 'Sync failed: ${e.toString()}';
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final authService = SpotifyAuthService(_db);
    return await authService.isAuthenticated();
  }
}

