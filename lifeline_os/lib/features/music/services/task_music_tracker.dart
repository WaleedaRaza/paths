import '../../../core/database/database.dart';
import '../repositories/music_repository.dart';
import 'spotify_api_client.dart';
import 'spotify_auth_service.dart';

/// Service for tracking music played during tasks
class TaskMusicTracker {
  final AppDatabase _db;
  final String? clientId;
  final String? clientSecret;

  TaskMusicTracker(this._db, {this.clientId, this.clientSecret});

  /// Log currently playing track against a task
  Future<void> logMusicForTask(String taskId) async {
    if (clientId == null || clientSecret == null) {
      return; // Can't fetch without credentials
    }

    try {
      // Get access token
      final authService = SpotifyAuthService(_db);
      final accessToken = await authService.getAccessToken(clientId!, clientSecret!);
      
      if (accessToken == null) {
        return; // Not authenticated
      }

      // Fetch currently playing
      final apiClient = SpotifyApiClient(accessToken);
      final nowPlaying = await apiClient.getCurrentlyPlaying();
      
      if (nowPlaying == null) {
        return; // Nothing playing
      }

      // Fetch artist to get genres
      final artist = await apiClient.getArtist(nowPlaying['artistId']);

      // Save this listen linked to the task
      final repo = MusicRepository(_db);
      await repo.saveListeningEvent(
        RecentlyPlayed(
          trackId: nowPlaying['id'],
          trackName: nowPlaying['name'],
          artistName: nowPlaying['artistName'],
          artistId: nowPlaying['artistId'],
          albumName: nowPlaying['albumName'],
          albumId: '', // Not critical
          genres: artist.genres,
          playedAt: DateTime.now(),
          durationMs: nowPlaying['durationMs'],
          context: 'during_task',
        ),
        taskId: taskId,
      );
    } catch (e) {
      // Silently fail - music tracking is optional
      print('Failed to log music for task: $e');
    }
  }

  /// Get music played during a specific task
  Future<List<SpotifyListen>> getMusicForTask(String taskId) async {
    return await (_db.select(_db.spotifyListens)
          ..where((tbl) => tbl.playedDuringTaskId.equals(taskId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.playedAt)]))
        .get();
  }

  /// Get most productive music (tracks played during completed tasks)
  Future<Map<String, int>> getProductiveMusic() async {
    // Get all tasks with linked music
    final listensWithTasks = await (_db.select(_db.spotifyListens)
          ..where((tbl) => tbl.playedDuringTaskId.isNotNull()))
        .get();

    // Get completed tasks
    final completedTaskIds = <String>{};
    final tasks = await (_db.select(_db.tasks)
          ..where((tbl) => tbl.isCompleted.equals(true)))
        .get();
    
    for (final task in tasks) {
      completedTaskIds.add(task.id);
    }

    // Count tracks played during completed tasks
    final trackCounts = <String, int>{};
    for (final listen in listensWithTasks) {
      if (listen.playedDuringTaskId != null && 
          completedTaskIds.contains(listen.playedDuringTaskId)) {
        final key = '${listen.trackName} - ${listen.artistName}';
        trackCounts[key] = (trackCounts[key] ?? 0) + 1;
      }
    }

    // Sort and return top 10
    final sorted = trackCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(sorted.take(10));
  }
}

