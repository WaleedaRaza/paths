import 'package:freezed_annotation/freezed_annotation.dart';

part 'subtask.freezed.dart';
part 'subtask.g.dart';

@freezed
class Subtask with _$Subtask {
  const factory Subtask({
    required String id,
    required String taskId,
    required String title,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    @Default(5) int points,
    @Default(0) int sortOrder,
    required DateTime createdAt,
  }) = _Subtask;

  factory Subtask.fromJson(Map<String, dynamic> json) =>
      _$SubtaskFromJson(json);
}

