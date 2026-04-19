// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      goalId: json['goalId'] as String?,
      categoryId: json['categoryId'] as String?,
      metadata: json['metadata'] as String?,
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']) ??
          TaskPriority.none,
      energy: $enumDecodeNullable(_$TaskEnergyEnumMap, json['energy']) ??
          TaskEnergy.none,
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      basePoints: (json['basePoints'] as num?)?.toInt() ?? 10,
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'goalId': instance.goalId,
      'categoryId': instance.categoryId,
      'metadata': instance.metadata,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'energy': _$TaskEnergyEnumMap[instance.energy]!,
      'estimatedMinutes': instance.estimatedMinutes,
      'dueDate': instance.dueDate?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'basePoints': instance.basePoints,
      'totalPoints': instance.totalPoints,
      'sortOrder': instance.sortOrder,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$TaskPriorityEnumMap = {
  TaskPriority.none: 'none',
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
};

const _$TaskEnergyEnumMap = {
  TaskEnergy.none: 'none',
  TaskEnergy.low: 'low',
  TaskEnergy.medium: 'medium',
  TaskEnergy.high: 'high',
};
