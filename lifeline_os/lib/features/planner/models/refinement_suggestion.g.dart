// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refinement_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RefinementSuggestionImpl _$$RefinementSuggestionImplFromJson(
        Map<String, dynamic> json) =>
    _$RefinementSuggestionImpl(
      action: json['action'] as String,
      fieldName: json['fieldName'] as String,
      notes: json['notes'] as String,
      guidance:
          (json['guidance'] as List<dynamic>).map((e) => e as String).toList(),
      proposedContentLines: (json['proposedContentLines'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      reasoning: json['reasoning'] as String?,
    );

Map<String, dynamic> _$$RefinementSuggestionImplToJson(
        _$RefinementSuggestionImpl instance) =>
    <String, dynamic>{
      'action': instance.action,
      'fieldName': instance.fieldName,
      'notes': instance.notes,
      'guidance': instance.guidance,
      'proposedContentLines': instance.proposedContentLines,
      'reasoning': instance.reasoning,
    };
