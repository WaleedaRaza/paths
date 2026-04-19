// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'must_win.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MustWinImpl _$$MustWinImplFromJson(Map<String, dynamic> json) =>
    _$MustWinImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      taskId: json['taskId'] as String?,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MustWinImplToJson(_$MustWinImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'taskId': instance.taskId,
      'title': instance.title,
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'sortOrder': instance.sortOrder,
      'createdAt': instance.createdAt.toIso8601String(),
    };
