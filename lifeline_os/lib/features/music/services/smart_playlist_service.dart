import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../../../core/database/database.dart';
import '../repositories/music_repository.dart';

/// Service for generating smart playlists based on listening patterns
class SmartPlaylistService {
  final AppDatabase _db;

  SmartPlaylistService(this._db);

  /// Generate "Morning Boost" playlist (high-energy morning tracks)
  Future<String> generateMorningBoost() async {
    final repo = MusicRepository(_db);
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    // Get tracks played between 6AM-9AM
    final allListens = await repo.getListensInRange(thirtyDaysAgo, now);
    final morningListens = allListens.where((listen) {
      final hour = listen.playedAt.hour;
      return hour >= 6 && hour <= 9;
    }).toList();

    // Count track plays
    final trackCounts = <String, int>{};
    for (final listen in morningListens) {
      trackCounts[listen.trackId] = (trackCounts[listen.trackId] ?? 0) + 1;
    }

    // Sort by play count and take top 25
    final sortedTracks = trackCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topTrackIds = sortedTracks.take(25).map((e) => e.key).toList();

    // Save playlist
    final id = const Uuid().v4();
    await _db.into(_db.smartPlaylists).insert(
      SmartPlaylistsCompanion.insert(
        id: id,
        name: '☀️ Morning Boost',
        criteria: 'morning',
        trackIds: topTrackIds.join(','),
        description: const Value('High-energy tracks from your 6-9AM listening'),
        lastGenerated: DateTime.now(),
      ),
    );

    return id;
  }

  /// Generate "Focus Mix" playlist (productive work music)
  Future<String> generateFocusMix() async {
    final repo = MusicRepository(_db);
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    // Get tracks played during typical work hours (2PM-5PM)
    final allListens = await repo.getListensInRange(thirtyDaysAgo, now);
    final focusListens = allListens.where((listen) {
      final hour = listen.playedAt.hour;
      return hour >= 14 && hour <= 17;
    }).toList();

    // Count track plays
    final trackCounts = <String, int>{};
    for (final listen in focusListens) {
      trackCounts[listen.trackId] = (trackCounts[listen.trackId] ?? 0) + 1;
    }

    // Sort by play count and take top 30
    final sortedTracks = trackCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topTrackIds = sortedTracks.take(30).map((e) => e.key).toList();

    // Save playlist
    final id = const Uuid().v4();
    await _db.into(_db.smartPlaylists).insert(
      SmartPlaylistsCompanion.insert(
        id: id,
        name: '🎯 Focus Mix',
        criteria: 'focus',
        trackIds: topTrackIds.join(','),
        description: const Value('Your most productive music from work sessions'),
        lastGenerated: DateTime.now(),
      ),
    );

    return id;
  }

  /// Generate "Wind Down" playlist (evening calm music)
  Future<String> generateWindDown() async {
    final repo = MusicRepository(_db);
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    // Get tracks played after 8PM
    final allListens = await repo.getListensInRange(thirtyDaysAgo, now);
    final eveningListens = allListens.where((listen) {
      final hour = listen.playedAt.hour;
      return hour >= 20 || hour <= 1; // 8PM to 1AM
    }).toList();

    // Count track plays
    final trackCounts = <String, int>{};
    for (final listen in eveningListens) {
      trackCounts[listen.trackId] = (trackCounts[listen.trackId] ?? 0) + 1;
    }

    // Sort by play count and take top 20
    final sortedTracks = trackCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topTrackIds = sortedTracks.take(20).map((e) => e.key).toList();

    // Save playlist
    final id = const Uuid().v4();
    await _db.into(_db.smartPlaylists).insert(
      SmartPlaylistsCompanion.insert(
        id: id,
        name: '🌙 Wind Down',
        criteria: 'wind_down',
        trackIds: topTrackIds.join(','),
        description: const Value('Calm tracks from your evening routine'),
        lastGenerated: DateTime.now(),
      ),
    );

    return id;
  }

  /// Generate all smart playlists
  Future<void> generateAll() async {
    await generateMorningBoost();
    await generateFocusMix();
    await generateWindDown();
  }

  /// Get all active playlists
  Future<List<SmartPlaylist>> getActivePlaylists() async {
    return await (_db.select(_db.smartPlaylists)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.lastGenerated)]))
        .get();
  }

  /// Delete a playlist
  Future<void> deletePlaylist(String id) async {
    await (_db.delete(_db.smartPlaylists)..where((tbl) => tbl.id.equals(id))).go();
  }
}

