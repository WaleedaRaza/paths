import 'package:freezed_annotation/freezed_annotation.dart';

part 'git_repo_config.freezed.dart';
part 'git_repo_config.g.dart';

@freezed
class GitRepoConfig with _$GitRepoConfig {
  const factory GitRepoConfig({
    required String id,
    required String name,
    required String githubUrl,
    required String localPath,
    DateTime? lastCommitAt,
    @Default('ssh') String authMethod,
    String? token,
    @Default(false) bool isLinked,
    required DateTime createdAt,
  }) = _GitRepoConfig;

  factory GitRepoConfig.fromJson(Map<String, dynamic> json) => _$GitRepoConfigFromJson(json);
}

