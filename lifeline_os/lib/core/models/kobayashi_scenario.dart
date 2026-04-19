import 'package:freezed_annotation/freezed_annotation.dart';

part 'kobayashi_scenario.freezed.dart';
part 'kobayashi_scenario.g.dart';

@freezed
class KobayashiScenario with _$KobayashiScenario {
  const factory KobayashiScenario({
    required String id,
    required String sessionId,
    required String role,
    required String context,
    required String traits,
    required String goals,
    String? winConditions,
    required DateTime createdAt,
  }) = _KobayashiScenario;

  factory KobayashiScenario.fromJson(Map<String, dynamic> json) =>
      _$KobayashiScenarioFromJson(json);
}

