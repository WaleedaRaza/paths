import 'package:drift/drift.dart';
import '../../../core/database/database.dart';
import '../models/git_repo_config.dart';

class GitReposRepository {
  final AppDatabase db;

  GitReposRepository(this.db);

  // Create new repo configuration
  Future<String> createRepo({
    required String name,
    required String githubUrl,
    required String localPath,
    String authMethod = 'ssh',
    String? token,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final repo = GitRepoConfig(
      id: id,
      name: name,
      githubUrl: githubUrl,
      localPath: localPath,
      authMethod: authMethod,
      token: token,
      isLinked: false,
      createdAt: DateTime.now(),
    );

    await db.into(db.gitRepos).insert(
      GitReposCompanion(
        id: Value(repo.id),
        name: Value(repo.name),
        githubUrl: Value(repo.githubUrl),
        localPath: Value(repo.localPath),
        authMethod: Value(repo.authMethod),
        token: Value(repo.token),
        isLinked: Value(repo.isLinked),
        createdAt: Value(repo.createdAt),
      ),
    );

    return id;
  }

  // Watch all repos
  Stream<List<GitRepoConfig>> watchAllRepos() {
    return (db.select(db.gitRepos)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .watch()
        .map((rows) => rows
            .map((row) => GitRepoConfig(
                  id: row.id,
                  name: row.name,
                  githubUrl: row.githubUrl,
                  localPath: row.localPath,
                  lastCommitAt: row.lastCommitAt,
                  authMethod: row.authMethod,
                  token: row.token,
                  isLinked: row.isLinked,
                  createdAt: row.createdAt,
                ))
            .toList());
  }

  // Get single repo
  Future<GitRepoConfig?> getRepo(String id) async {
    final query = db.select(db.gitRepos)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    return GitRepoConfig(
      id: row.id,
      name: row.name,
      githubUrl: row.githubUrl,
      localPath: row.localPath,
      lastCommitAt: row.lastCommitAt,
      authMethod: row.authMethod,
      token: row.token,
      isLinked: row.isLinked,
      createdAt: row.createdAt,
    );
  }

  // Update repo
  Future<void> updateRepo(GitRepoConfig config) async {
    await (db.update(db.gitRepos)..where((tbl) => tbl.id.equals(config.id)))
        .write(
      GitReposCompanion(
        name: Value(config.name),
        githubUrl: Value(config.githubUrl),
        localPath: Value(config.localPath),
        lastCommitAt: Value(config.lastCommitAt),
        authMethod: Value(config.authMethod),
        token: Value(config.token),
        isLinked: Value(config.isLinked),
      ),
    );
  }

  // Delete repo
  Future<void> deleteRepo(String id) async {
    await (db.delete(db.gitRepos)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Update last commit timestamp
  Future<void> updateLastCommit(String id, DateTime timestamp) async {
    await (db.update(db.gitRepos)..where((tbl) => tbl.id.equals(id)))
        .write(GitReposCompanion(lastCommitAt: Value(timestamp)));
  }
}

