import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_entry.freezed.dart';
part 'log_entry.g.dart';

@freezed
class LogEntry with _$LogEntry {
  const factory LogEntry({
    required String id,
    required String type, // 'workout', 'reading', 'meditation', etc.
    required String title,
    String? description,
    int? durationMinutes,
    required DateTime logDate,
    @Default(5) int points,
    required DateTime createdAt,
  }) = _LogEntry;

  factory LogEntry.fromJson(Map<String, dynamic> json) =>
      _$LogEntryFromJson(json);
}

