// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mgtst_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MGTSTSuggestionImpl _$$MGTSTSuggestionImplFromJson(
        Map<String, dynamic> json) =>
    _$MGTSTSuggestionImpl(
      mission:
          MissionSuggestion.fromJson(json['mission'] as Map<String, dynamic>),
      goals: (json['goals'] as List<dynamic>)
          .map((e) => GoalSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String,
    );

Map<String, dynamic> _$$MGTSTSuggestionImplToJson(
        _$MGTSTSuggestionImpl instance) =>
    <String, dynamic>{
      'mission': instance.mission,
      'goals': instance.goals,
      'notes': instance.notes,
    };

_$MissionSuggestionImpl _$$MissionSuggestionImplFromJson(
        Map<String, dynamic> json) =>
    _$MissionSuggestionImpl(
      suggestedTitle: json['suggestedTitle'] as String,
      rationale: json['rationale'] as String,
    );

Map<String, dynamic> _$$MissionSuggestionImplToJson(
        _$MissionSuggestionImpl instance) =>
    <String, dynamic>{
      'suggestedTitle': instance.suggestedTitle,
      'rationale': instance.rationale,
    };

_$GoalSuggestionImpl _$$GoalSuggestionImplFromJson(Map<String, dynamic> json) =>
    _$GoalSuggestionImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => TaskSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      selected: json['selected'] as bool? ?? true,
    );

Map<String, dynamic> _$$GoalSuggestionImplToJson(
        _$GoalSuggestionImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'tasks': instance.tasks,
      'selected': instance.selected,
    };

_$TaskSuggestionImpl _$$TaskSuggestionImplFromJson(Map<String, dynamic> json) =>
    _$TaskSuggestionImpl(
      title: json['title'] as String,
      priority: json['priority'] as String? ?? 'medium',
      energy: json['energy'] as String? ?? 'medium',
      selected: json['selected'] as bool? ?? true,
    );

Map<String, dynamic> _$$TaskSuggestionImplToJson(
        _$TaskSuggestionImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'priority': instance.priority,
      'energy': instance.energy,
      'selected': instance.selected,
    };
