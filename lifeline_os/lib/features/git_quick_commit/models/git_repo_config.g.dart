// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'git_repo_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GitRepoConfigImpl _$$GitRepoConfigImplFromJson(Map<String, dynamic> json) =>
    _$GitRepoConfigImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      githubUrl: json['githubUrl'] as String,
      localPath: json['localPath'] as String,
      lastCommitAt: json['lastCommitAt'] == null
          ? null
          : DateTime.parse(json['lastCommitAt'] as String),
      authMethod: json['authMethod'] as String? ?? 'ssh',
      token: json['token'] as String?,
      isLinked: json['isLinked'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$GitRepoConfigImplToJson(_$GitRepoConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'githubUrl': instance.githubUrl,
      'localPath': instance.localPath,
      'lastCommitAt': instance.lastCommitAt?.toIso8601String(),
      'authMethod': instance.authMethod,
      'token': instance.token,
      'isLinked': instance.isLinked,
      'createdAt': instance.createdAt.toIso8601String(),
    };
