import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:langchain/langchain.dart';
import '../../../core/database/database.dart';
import '../repositories/music_repository.dart';

/// Service for generating LLM-powered music insights
class MusicLLMService {
  final AppDatabase _db;
  final BaseChatModel llm;

  MusicLLMService(this._db, this.llm);

  /// Generate weekly insight based on listening data
  Future<String> generateWeeklyInsight() async {
    final repo = MusicRepository(_db);
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final weekEnd = weekStartDate.add(const Duration(days: 7));

    // Fetch this week's data
    final listens = await repo.getListensInRange(weekStartDate, weekEnd);
    final topArtists = await repo.getTopArtists(weekStartDate, weekEnd, limit: 5);
    final topGenres = await repo.getTopGenres(weekStartDate, weekEnd, limit: 3);
    final totalMinutes = await repo.getTotalMinutes(weekStartDate, weekEnd);
    final newArtists = await repo.getNewArtistsCount(weekStartDate, weekEnd);

    // Parse top artist names from keys (format: "id:name")
    final topArtistsList = topArtists.entries
        .map((e) => '${e.key.split(':').last} (${e.value} plays)')
        .toList();

    // Parse genres
    final topGenresList = topGenres.entries
        .map((e) => '${e.key} (${e.value}x)')
        .toList();

    // Build prompt
    final prompt = '''Analyze this week's listening data and provide a casual, insightful summary.

DATA:
- Total listening time: ${(totalMinutes / 60).toStringAsFixed(1)} hours
- Total tracks: ${listens.length}
- Top 5 artists: ${topArtistsList.join(', ')}
- Top genres: ${topGenresList.join(', ')}
- New artists discovered: $newArtists

INSTRUCTIONS:
Write 2-3 sentences that:
1. Highlight one interesting pattern or trend
2. Give one recommendation (artist to try, or observation about their taste)
3. Celebrate something if applicable (new discoveries, consistency, etc.)

Keep it casual, not robotic. Write like a music-savvy friend giving advice.
NO MARKDOWN. NO FORMATTING. Just plain conversational text.''';

    final response = await llm.invoke(PromptValue.string(prompt));
    final insight = response.output.toString().trim();

    // Save to database
    final id = const Uuid().v4();
    await _db.into(_db.musicInsights).insert(
      MusicInsightsCompanion.insert(
        id: id,
        weekOf: weekStartDate,
        llmAnalysis: insight,
        dataSnapshot: jsonEncode({
          'totalMinutes': totalMinutes,
          'topArtists': topArtists.map((k, v) => MapEntry(k, v)),
          'topGenres': topGenres.map((k, v) => MapEntry(k, v)),
          'newArtists': newArtists,
        }),
      ),
    );

    return insight;
  }

  /// Get latest insight
  Future<MusicInsight?> getLatestInsight() async {
    return await (_db.select(_db.musicInsights)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.weekOf)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Mark insight as read
  Future<void> markInsightRead(String id) async {
    await (_db.update(_db.musicInsights)..where((tbl) => tbl.id.equals(id))).write(
      const MusicInsightsCompanion(
        hasBeenRead: Value(true),
      ),
    );
  }
}

