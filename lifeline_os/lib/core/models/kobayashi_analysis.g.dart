// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kobayashi_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KobayashiAnalysisImpl _$$KobayashiAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$KobayashiAnalysisImpl(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      overallScore: (json['overallScore'] as num).toInt(),
      strengths:
          (json['strengths'] as List<dynamic>).map((e) => e as String).toList(),
      weaknesses: (json['weaknesses'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      transcript: json['transcript'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$KobayashiAnalysisImplToJson(
        _$KobayashiAnalysisImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'overallScore': instance.overallScore,
      'strengths': instance.strengths,
      'weaknesses': instance.weaknesses,
      'recommendations': instance.recommendations,
      'transcript': instance.transcript,
      'createdAt': instance.createdAt.toIso8601String(),
    };
