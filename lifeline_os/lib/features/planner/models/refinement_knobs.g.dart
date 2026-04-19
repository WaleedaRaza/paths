// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refinement_knobs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RefinementKnobsImpl _$$RefinementKnobsImplFromJson(
        Map<String, dynamic> json) =>
    _$RefinementKnobsImpl(
      listOnly: json['listOnly'] as bool? ?? false,
      targetCount: (json['targetCount'] as num?)?.toInt() ?? 8,
      includeExamples: json['includeExamples'] as bool? ?? false,
      forbidPhrases: (json['forbidPhrases'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      mustInclude: (json['mustInclude'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.5,
      noveltyThreshold: (json['noveltyThreshold'] as num?)?.toDouble() ?? 0.3,
    );

Map<String, dynamic> _$$RefinementKnobsImplToJson(
        _$RefinementKnobsImpl instance) =>
    <String, dynamic>{
      'listOnly': instance.listOnly,
      'targetCount': instance.targetCount,
      'includeExamples': instance.includeExamples,
      'forbidPhrases': instance.forbidPhrases,
      'mustInclude': instance.mustInclude,
      'temperature': instance.temperature,
      'noveltyThreshold': instance.noveltyThreshold,
    };
