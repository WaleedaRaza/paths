// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kobayashi_scenario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KobayashiScenarioImpl _$$KobayashiScenarioImplFromJson(
        Map<String, dynamic> json) =>
    _$KobayashiScenarioImpl(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      role: json['role'] as String,
      context: json['context'] as String,
      traits: json['traits'] as String,
      goals: json['goals'] as String,
      winConditions: json['winConditions'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$KobayashiScenarioImplToJson(
        _$KobayashiScenarioImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'role': instance.role,
      'context': instance.context,
      'traits': instance.traits,
      'goals': instance.goals,
      'winConditions': instance.winConditions,
      'createdAt': instance.createdAt.toIso8601String(),
    };
