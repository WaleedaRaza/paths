import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

@freezed
class Goal with _$Goal {
  const factory Goal({
    required String id,
    required String title,
    String? description,
    String? milestoneId,
    String? parentGoalId,
    String? metadata, // JSON string for domain-specific data
    @Default(0) int sortOrder,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    @Default(0) int totalPoints,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}

