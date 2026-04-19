import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

enum TaskPriority { none, low, medium, high }

enum TaskEnergy { none, low, medium, high }

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    String? description,
    String? goalId,
    String? categoryId,
    String? metadata, // JSON string for domain-specific data
    @Default(TaskPriority.none) TaskPriority priority,
    @Default(TaskEnergy.none) TaskEnergy energy,
    int? estimatedMinutes,
    DateTime? dueDate,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    @Default(10) int basePoints,
    @Default(0) int totalPoints,
    @Default(0) int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

