import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../../../core/database/database.dart';
import '../repositories/music_repository.dart';

/// Service for aggregating music statistics
class MusicStatsService {
  final AppDatabase _db;

  MusicStatsService(this._db);

  /// Aggregate stats for a specific period
  Future<void> aggregateStats(DateTime date, String period) async {
    final repo = MusicRepository(_db);
    DateTime start, end;

    // Calculate date range based on period
    switch (period) {
      case 'day':
        start = DateTime(date.year, date.month, date.day);
        end = start.add(const Duration(days: 1)).subtract(const Duration(seconds: 1));
        break;
      case 'week':
        // Start of week (Monday)
        final weekday = date.weekday;
        start = date.subtract(Duration(days: weekday - 1));
        start = DateTime(start.year, start.month, start.day);
        end = start.add(const Duration(days: 7)).subtract(const Duration(seconds: 1));
        break;
      case 'month':
        start = DateTime(date.year, date.month, 1);
        end = DateTime(date.year, date.month + 1, 1).subtract(const Duration(seconds: 1));
        break;
      case 'year':
        start = DateTime(date.year, 1, 1);
        end = DateTime(date.year + 1, 1, 1).subtract(const Duration(seconds: 1));
        break;
      default:
        throw Exception('Invalid period: $period');
    }

    // Fetch aggregated data
    final topArtists = await repo.getTopArtists(start, end, limit: 20);
    final topTracks = await repo.getTopTracks(start, end, limit: 20);
    final topGenres = await repo.getTopGenres(start, end, limit: 10);
    final totalMinutes = await repo.getTotalMinutes(start, end);
    final uniqueArtists = await repo.getUniqueArtistCount(start, end);
    final newArtists = await repo.getNewArtistsCount(start, end);
    final hourlyPattern = await repo.getHourlyPattern(start, end);

    // Get unique track count
    final listens = await repo.getListensInRange(start, end);
    final uniqueTracks = listens.map((l) => l.trackId).toSet().length;

    // Save or update stats
    final id = '${period}_${start.toIso8601String()}';
    
    await _db.into(_db.musicStats).insertOnConflictUpdate(
      MusicStatsCompanion.insert(
        id: id,
        date: start,
        period: period,
        topArtists: jsonEncode(topArtists.map((k, v) => MapEntry(k, v))),
        topTracks: jsonEncode(topTracks.map((k, v) => MapEntry(k, v))),
        topGenres: jsonEncode(topGenres.map((k, v) => MapEntry(k, v))),
        totalMinutes: Value(totalMinutes),
        uniqueArtists: Value(uniqueArtists),
        uniqueTracks: Value(uniqueTracks),
        newArtistsDiscovered: Value(newArtists),
        hourlyMinutes: jsonEncode(hourlyPattern.map((k, v) => MapEntry(k.toString(), v))),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Aggregate today's stats
  Future<void> aggregateToday() async {
    await aggregateStats(DateTime.now(), 'day');
  }

  /// Aggregate this week's stats
  Future<void> aggregateThisWeek() async {
    await aggregateStats(DateTime.now(), 'week');
  }

  /// Aggregate this month's stats
  Future<void> aggregateThisMonth() async {
    await aggregateStats(DateTime.now(), 'month');
  }

  /// Aggregate this year's stats
  Future<void> aggregateThisYear() async {
    await aggregateStats(DateTime.now(), 'year');
  }

  /// Run full aggregation (day + week + month + year)
  Future<void> aggregateAll() async {
    final now = DateTime.now();
    await aggregateStats(now, 'day');
    await aggregateStats(now, 'week');
    await aggregateStats(now, 'month');
    await aggregateStats(now, 'year');
  }

  /// Get stats for a period
  Future<MusicStat?> getStats(DateTime date, String period) async {
    DateTime start;
    
    switch (period) {
      case 'day':
        start = DateTime(date.year, date.month, date.day);
        break;
      case 'week':
        final weekday = date.weekday;
        start = date.subtract(Duration(days: weekday - 1));
        start = DateTime(start.year, start.month, start.day);
        break;
      case 'month':
        start = DateTime(date.year, date.month, 1);
        break;
      case 'year':
        start = DateTime(date.year, 1, 1);
        break;
      default:
        throw Exception('Invalid period: $period');
    }

    final id = '${period}_${start.toIso8601String()}';
    
    return await (_db.select(_db.musicStats)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }
}

