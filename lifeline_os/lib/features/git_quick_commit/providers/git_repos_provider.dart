import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_provider.dart';
import '../models/git_repo_config.dart';
import '../repositories/git_repos_repository.dart';
import '../services/git_service.dart';

// Repository provider
final gitReposRepositoryProvider = Provider<GitReposRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return GitReposRepository(db);
});

// Git service provider
final gitServiceProvider = Provider<GitService>((ref) {
  return GitService();
});

// Watch all repos
final allGitReposProvider = StreamProvider<List<GitRepoConfig>>((ref) {
  final repo = ref.watch(gitReposRepositoryProvider);
  return repo.watchAllRepos();
});

// Link repo action (init/set remote)
final linkRepoProvider = Provider<Future<void> Function(GitRepoConfig)>((ref) {
  return (GitRepoConfig config) async {
    final service = ref.read(gitServiceProvider);
    final repo = ref.read(gitReposRepositoryProvider);
    
    // Check if git repo exists, init if needed
    if (!await service.isGitRepo(config.localPath)) {
      await service.initRepo(config.localPath, config.githubUrl);
    } else if (!await service.hasRemote(config.localPath)) {
      await service.setRemote(config.localPath, config.githubUrl);
    }
    
    // Mark as linked
    await repo.updateRepo(config.copyWith(isLinked: true));
  };
});

// Quick commit action
final quickCommitProvider = Provider<Future<void> Function(GitRepoConfig, String)>((ref) {
  return (GitRepoConfig config, String message) async {
    final service = ref.read(gitServiceProvider);
    final repo = ref.read(gitReposRepositoryProvider);
    
    final timestamp = DateTime.now().toIso8601String();
    final fullMessage = '$message [$timestamp]';
    
    await service.stageAll(config.localPath);
    await service.commit(config.localPath, fullMessage);
    await service.push(config.localPath, token: config.token);
    
    await repo.updateLastCommit(config.id, DateTime.now());
  };
});

