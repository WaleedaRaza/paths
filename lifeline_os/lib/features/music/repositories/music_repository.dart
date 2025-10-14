import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database.dart';
import '../models/spotify_track.dart';

/// Repository for managing music listening data
class MusicRepository {
  final AppDatabase _db;

  MusicRepository(this._db);

  /// Save a listening event
  Future<String> saveListeningEvent(RecentlyPlayed track, {String? taskId}) async {
    final id = const Uuid().v4();
    
    // Check if this exact event already exists (deduplication)
    final existing = await (_db.select(_db.spotifyListens)
          ..where((tbl) =>
              tbl.trackId.equals(track.trackId) &
              tbl.playedAt.equals(track.playedAt)))
        .getSingleOrNull();

    if (existing != null) {
      return existing.id; // Already saved
    }

    await _db.into(_db.spotifyListens).insert(
      SpotifyListensCompanion.insert(
        id: id,
        trackId: track.trackId,
        trackName: track.trackName,
        artistName: track.artistName,
        artistId: track.artistId,
        albumName: track.albumName,
        albumId: track.albumId,
        genres: track.genres.join(','), // CSV for now
        playedAt: track.playedAt,
        durationMs: track.durationMs,
        context: Value(track.context),
        playedDuringTaskId: Value(taskId),
      ),
    );

    return id;
  }

  /// Get all listening events in a date range
  Future<List<SpotifyListen>> getListensInRange(DateTime start, DateTime end) async {
    return await (_db.select(_db.spotifyListens)
          ..where((tbl) =>
              tbl.playedAt.isBiggerOrEqual(start) &
              tbl.playedAt.isSmallerOrEqual(end))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.playedAt)]))
        .get();
  }

  /// Get total listening minutes for a date range
  Future<int> getTotalMinutes(DateTime start, DateTime end) async {
    final listens = await getListensInRange(start, end);
    int total = 0;
    for (final listen in listens) {
      total += listen.durationMs ~/ 60000;
    }
    return total;
  }

  /// Get top artists for a date range
  Future<Map<String, int>> getTopArtists(DateTime start, DateTime end, {int limit = 10}) async {
    final listens = await getListensInRange(start, end);
    final artistCounts = <String, int>{};

    for (final listen in listens) {
      final key = '${listen.artistId}:${listen.artistName}';
      artistCounts[key] = (artistCounts[key] ?? 0) + 1;
    }

    // Sort by play count and take top N
    final sorted = artistCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(sorted.take(limit));
  }

  /// Get top tracks for a date range
  Future<Map<String, int>> getTopTracks(DateTime start, DateTime end, {int limit = 10}) async {
    final listens = await getListensInRange(start, end);
    final trackCounts = <String, int>{};

    for (final listen in listens) {
      final key = '${listen.trackId}:${listen.trackName}:${listen.artistName}';
      trackCounts[key] = (trackCounts[key] ?? 0) + 1;
    }

    // Sort by play count and take top N
    final sorted = trackCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(sorted.take(limit));
  }

  /// Get top genres for a date range
  Future<Map<String, int>> getTopGenres(DateTime start, DateTime end, {int limit = 5}) async {
    final listens = await getListensInRange(start, end);
    final genreCounts = <String, int>{};

    for (final listen in listens) {
      if (listen.genres.isEmpty) continue;
      
      final genres = listen.genres.split(',');
      for (final genre in genres) {
        if (genre.trim().isNotEmpty) {
          genreCounts[genre.trim()] = (genreCounts[genre.trim()] ?? 0) + 1;
        }
      }
    }

    // Sort by count and take top N
    final sorted = genreCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(sorted.take(limit));
  }

  /// Get hourly listening pattern (hour -> minutes)
  Future<Map<int, int>> getHourlyPattern(DateTime start, DateTime end) async {
    final listens = await getListensInRange(start, end);
    final hourlyMinutes = <int, int>{};

    for (final listen in listens) {
      final hour = listen.playedAt.hour;
      final minutes = listen.durationMs ~/ 60000;
      hourlyMinutes[hour] = (hourlyMinutes[hour] ?? 0) + minutes;
    }

    return hourlyMinutes;
  }

  /// Get unique artist count for a date range
  Future<int> getUniqueArtistCount(DateTime start, DateTime end) async {
    final listens = await getListensInRange(start, end);
    final uniqueArtists = listens.map((l) => l.artistId).toSet();
    return uniqueArtists.length;
  }

  /// Get new artists discovered in a date range
  Future<int> getNewArtistsCount(DateTime start, DateTime end) async {
    final listens = await getListensInRange(start, end);
    final artistsInPeriod = listens.map((l) => l.artistId).toSet();
    
    // Get all artists listened to before this period
    final beforeStart = start.subtract(const Duration(days: 365)); // Check last year
    final previousListens = await getListensInRange(beforeStart, start);
    final previousArtists = previousListens.map((l) => l.artistId).toSet();
    
    // New artists = in current period but not in previous
    final newArtists = artistsInPeriod.difference(previousArtists);
    return newArtists.length;
  }

  /// Get last sync time (most recent playedAt)
  Future<DateTime?> getLastSyncTime() async {
    final recent = await (_db.select(_db.spotifyListens)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.playedAt)])
          ..limit(1))
        .getSingleOrNull();
    
    return recent?.playedAt;
  }

  /// Delete old listening data (cleanup)
  Future<void> deleteOldListens(DateTime before) async {
    await (_db.delete(_db.spotifyListens)
          ..where((tbl) => tbl.playedAt.isSmallerThan(before)))
        .go();
  }
}

