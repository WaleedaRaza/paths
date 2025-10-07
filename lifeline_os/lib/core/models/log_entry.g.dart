// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LogEntryImpl _$$LogEntryImplFromJson(Map<String, dynamic> json) =>
    _$LogEntryImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      logDate: DateTime.parse(json['logDate'] as String),
      points: (json['points'] as num?)?.toInt() ?? 5,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$LogEntryImplToJson(_$LogEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'durationMinutes': instance.durationMinutes,
      'logDate': instance.logDate.toIso8601String(),
      'points': instance.points,
      'createdAt': instance.createdAt.toIso8601String(),
    };
