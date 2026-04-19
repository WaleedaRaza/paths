// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MilestoneImpl _$$MilestoneImplFromJson(Map<String, dynamic> json) =>
    _$MilestoneImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      categoryId: json['categoryId'] as String?,
      domain: $enumDecodeNullable(_$DomainEnumMap, json['domain']) ??
          Domain.personal,
      metadata: json['metadata'] as String?,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MilestoneImplToJson(_$MilestoneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'domain': _$DomainEnumMap[instance.domain]!,
      'metadata': instance.metadata,
      'deadline': instance.deadline?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'totalPoints': instance.totalPoints,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$DomainEnumMap = {
  Domain.school: 'school',
  Domain.projects: 'projects',
  Domain.finance: 'finance',
  Domain.health: 'health',
  Domain.dsa: 'dsa',
  Domain.career: 'career',
  Domain.gre: 'gre',
  Domain.personal: 'personal',
};
