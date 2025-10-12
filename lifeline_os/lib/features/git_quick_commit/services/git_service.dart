import 'dart:io';

class GitService {
  // Check if a directory is a git repository
  Future<bool> isGitRepo(String path) async {
    final gitDir = Directory('$path/.git');
    return await gitDir.exists();
  }

  // Initialize a git repository and set remote
  Future<void> initRepo(String path, String remoteUrl) async {
    // Git init
    final initResult = await Process.run(
      'git',
      ['init'],
      workingDirectory: path,
    );

    if (initResult.exitCode != 0) {
      throw Exception('Failed to init git repo: ${initResult.stderr}');
    }

    // Add remote
    final remoteResult = await Process.run(
      'git',
      ['remote', 'add', 'origin', remoteUrl],
      workingDirectory: path,
    );

    if (remoteResult.exitCode != 0) {
      throw Exception('Failed to add remote: ${remoteResult.stderr}');
    }
  }

  // Check if remote is configured
  Future<bool> hasRemote(String path) async {
    final result = await Process.run(
      'git',
      ['remote', 'get-url', 'origin'],
      workingDirectory: path,
    );

    return result.exitCode == 0;
  }

  // Set or update remote URL
  Future<void> setRemote(String path, String remoteUrl) async {
    final hasRemoteUrl = await hasRemote(path);

    final args = hasRemoteUrl
        ? ['remote', 'set-url', 'origin', remoteUrl]
        : ['remote', 'add', 'origin', remoteUrl];

    final result = await Process.run(
      'git',
      args,
      workingDirectory: path,
    );

    if (result.exitCode != 0) {
      throw Exception('Failed to set remote: ${result.stderr}');
    }
  }

  // Stage all changes
  Future<void> stageAll(String path) async {
    final result = await Process.run(
      'git',
      ['add', '-A'],
      workingDirectory: path,
    );

    if (result.exitCode != 0) {
      throw Exception('Failed to stage files: ${result.stderr}');
    }
  }

  // Commit changes
  Future<void> commit(String path, String message) async {
    final result = await Process.run(
      'git',
      ['commit', '-m', message],
      workingDirectory: path,
    );

    if (result.exitCode != 0) {
      final stderr = result.stderr.toString();
      // Allow "nothing to commit" as success
      if (!stderr.contains('nothing to commit') && !stderr.contains('no changes added')) {
        throw Exception('Failed to commit: $stderr');
      }
    }
  }

  // Push to remote
  Future<void> push(String path, {String? token}) async {
    List<String> args;
    
    if (token != null && token.isNotEmpty) {
      // For token auth, we need to set the remote URL with token
      final remoteUrl = await _getRemoteUrl(path);
      if (remoteUrl != null) {
        final urlWithToken = _injectToken(remoteUrl, token);
        args = ['push', urlWithToken, 'HEAD'];
      } else {
        throw Exception('No remote URL found');
      }
    } else {
      // SSH or already configured credentials
      args = ['push', '-u', 'origin', 'HEAD'];
    }

    final result = await Process.run(
      'git',
      args,
      workingDirectory: path,
    );

    if (result.exitCode != 0) {
      throw Exception('Failed to push: ${result.stderr}');
    }
  }

  // Get git status (short format)
  Future<String> getStatus(String path) async {
    final result = await Process.run(
      'git',
      ['status', '--short'],
      workingDirectory: path,
    );

    if (result.exitCode != 0) {
      throw Exception('Failed to get status: ${result.stderr}');
    }

    return result.stdout.toString();
  }

  // Helper: Get remote URL
  Future<String?> _getRemoteUrl(String path) async {
    final result = await Process.run(
      'git',
      ['remote', 'get-url', 'origin'],
      workingDirectory: path,
    );

    if (result.exitCode == 0) {
      return result.stdout.toString().trim();
    }
    return null;
  }

  // Helper: Inject token into HTTPS URL
  String _injectToken(String url, String token) {
    // Convert git@github.com:user/repo.git to https://token@github.com/user/repo.git
    if (url.startsWith('git@')) {
      url = url
          .replaceFirst('git@', 'https://')
          .replaceFirst('.com:', '.com/');
    }

    // Inject token into HTTPS URL
    if (url.startsWith('https://')) {
      return url.replaceFirst('https://', 'https://$token@');
    }

    return url;
  }
}

