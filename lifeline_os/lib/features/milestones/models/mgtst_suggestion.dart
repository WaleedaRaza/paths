import 'package:freezed_annotation/freezed_annotation.dart';

part 'mgtst_suggestion.freezed.dart';
part 'mgtst_suggestion.g.dart';

/// AI-generated suggestion for Mission/Goals/Tasks structure
@freezed
class MGTSTSuggestion with _$MGTSTSuggestion {
  const factory MGTSTSuggestion({
    required MissionSuggestion mission,
    required List<GoalSuggestion> goals,
    required String notes,
  }) = _MGTSTSuggestion;
  
  factory MGTSTSuggestion.fromJson(Map<String, dynamic> json) =>
      _$MGTSTSuggestionFromJson(json);
}

/// Suggested mission (milestone) details
@freezed
class MissionSuggestion with _$MissionSuggestion {
  const factory MissionSuggestion({
    required String suggestedTitle,
    required String rationale,
  }) = _MissionSuggestion;
  
  factory MissionSuggestion.fromJson(Map<String, dynamic> json) =>
      _$MissionSuggestionFromJson(json);
}

/// Suggested goal with nested tasks
@freezed
class GoalSuggestion with _$GoalSuggestion {
  const factory GoalSuggestion({
    required String title,
    required String description,
    required List<TaskSuggestion> tasks,
    @Default(true) bool selected, // For UI selection
  }) = _GoalSuggestion;
  
  factory GoalSuggestion.fromJson(Map<String, dynamic> json) =>
      _$GoalSuggestionFromJson(json);
}

/// Suggested task details
@freezed
class TaskSuggestion with _$TaskSuggestion {
  const factory TaskSuggestion({
    required String title,
    @Default('medium') String priority, // low, medium, high
    @Default('medium') String energy, // low, medium, high
    @Default(true) bool selected, // For UI selection
  }) = _TaskSuggestion;
  
  factory TaskSuggestion.fromJson(Map<String, dynamic> json) =>
      _$TaskSuggestionFromJson(json);
}

