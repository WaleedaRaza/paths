import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_provider.dart';
import '../repositories/music_repository.dart';
import '../services/spotify_auth_service.dart';
import '../services/spotify_sync_service.dart';
import '../services/music_stats_service.dart';
import '../../../core/database/database.dart';

// Repository provider
final musicRepositoryProvider = Provider<MusicRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return MusicRepository(db);
});

// Auth service provider
final spotifyAuthServiceProvider = Provider<SpotifyAuthService>((ref) {
  final db = ref.watch(databaseProvider);
  return SpotifyAuthService(db);
});

// Sync service provider (requires client credentials from settings)
final spotifySyncServiceProvider = Provider.family<SpotifySyncService, (String, String)>((ref, credentials) {
  final db = ref.watch(databaseProvider);
  return SpotifySyncService(db, credentials.$1, credentials.$2);
});

// Stats service provider
final musicStatsServiceProvider = Provider<MusicStatsService>((ref) {
  final db = ref.watch(databaseProvider);
  return MusicStatsService(db);
});

// Is authenticated provider
final isSpotifyAuthenticatedProvider = StreamProvider<bool>((ref) async* {
  final db = ref.watch(databaseProvider);
  
  yield* db.select(db.spotifyTokens).watch().map((tokens) => tokens.isNotEmpty);
});

// Recent listens provider (last 7 days)
final recentListensProvider = StreamProvider<List<SpotifyListen>>((ref) {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final sevenDaysAgo = now.subtract(const Duration(days: 7));
  
  return (db.select(db.spotifyListens)
        ..where((tbl) =>
            tbl.playedAt.isBiggerOrEqualValue(sevenDaysAgo))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.playedAt)]))
      .watch();
});

// Total minutes listened (all time)
final totalListeningMinutesProvider = StreamProvider<int>((ref) async* {
  final db = ref.watch(databaseProvider);
  
  final query = db.selectOnly(db.spotifyListens)
    ..addColumns([db.spotifyListens.durationMs.sum()]);
  
  await for (final rows in query.watch()) {
    final sum = rows.first.read(db.spotifyListens.durationMs.sum());
    yield (sum ?? 0) ~/ 60000; // Convert to minutes
  }
});

// Listening streak (consecutive days with listens)
final listeningStreakProvider = StreamProvider<int>((ref) async* {
  final db = ref.watch(databaseProvider);
  
  // Get all listens grouped by date
  final listens = await (db.select(db.spotifyListens)
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.playedAt)]))
      .get();

  if (listens.isEmpty) {
    yield 0;
    return;
  }

  int streak = 0;
  DateTime? lastDate;
  final Set<String> countedDates = {};

  for (final listen in listens) {
    final listenDate = DateTime(
      listen.playedAt.year,
      listen.playedAt.month,
      listen.playedAt.day,
    );
    
    final dateKey = '${listenDate.year}-${listenDate.month}-${listenDate.day}';

    if (lastDate == null) {
      // First iteration
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      
      // Check if most recent listen was today or yesterday
      if (listenDate == todayDate || 
          listenDate == todayDate.subtract(const Duration(days: 1))) {
        lastDate = listenDate;
        countedDates.add(dateKey);
        streak++;
      } else {
        break; // Streak broken
      }
    } else {
      final expectedDate = lastDate.subtract(const Duration(days: 1));
      if (listenDate == expectedDate && !countedDates.contains(dateKey)) {
        lastDate = listenDate;
        countedDates.add(dateKey);
        streak++;
      } else if (listenDate == lastDate) {
        continue; // Same day, already counted
      } else if (listenDate.isBefore(expectedDate)) {
        break; // Streak broken
      }
    }
  }

  yield streak;
});

// Last sync time provider
final lastSyncTimeProvider = FutureProvider<DateTime?>((ref) async {
  final repo = ref.watch(musicRepositoryProvider);
  return await repo.getLastSyncTime();
});

// Sync action provider
final syncSpotifyProvider = FutureProvider.family<String, (String, String)>((ref, credentials) async {
  final syncService = ref.watch(spotifySyncServiceProvider(credentials));
  return await syncService.syncWithStatus();
});

