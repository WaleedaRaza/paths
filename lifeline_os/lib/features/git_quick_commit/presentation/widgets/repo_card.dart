import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../app/theme.dart';
import '../../models/git_repo_config.dart';
import '../../providers/git_repos_provider.dart';
import 'commit_dialog.dart';

class RepoCard extends ConsumerWidget {
  final GitRepoConfig repo;

  const RepoCard({super.key, required this.repo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with name and status
          Row(
            children: [
              Expanded(
                child: Text(
                  repo.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusBadge(),
              IconButton(
                onPressed: () => _showDeleteConfirmation(context, ref),
                icon: const Icon(LucideIcons.trash2, size: 16),
                color: AppColors.textTertiary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // GitHub URL
          Row(
            children: [
              const Icon(LucideIcons.github, size: 12, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  repo.githubUrl,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Local path
          Row(
            children: [
              const Icon(LucideIcons.folder, size: 12, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _truncatePath(repo.localPath),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Last commit info
          if (repo.lastCommitAt != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Last commit: ${timeago.format(repo.lastCommitAt!)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ),

          // Action buttons
          Row(
            children: [
              if (!repo.isLinked)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _linkRepo(context, ref),
                    icon: const Icon(LucideIcons.link, size: 14),
                    label: const Text('Link'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              if (repo.isLinked)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showCommitDialog(context),
                    icon: const Icon(LucideIcons.upload, size: 14),
                    label: const Text('Commit & Push'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: repo.isLinked ? Colors.green.withOpacity(0.2) : AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        repo.isLinked ? 'Linked' : 'Not Linked',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: repo.isLinked ? Colors.green : AppColors.textTertiary,
        ),
      ),
    );
  }

  String _truncatePath(String path) {
    if (path.length <= 40) return path;
    return '...${path.substring(path.length - 37)}';
  }

  Future<void> _linkRepo(BuildContext context, WidgetRef ref) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Linking repository...'),
            ],
          ),
        ),
      );

      await ref.read(linkRepoProvider)(repo);

      if (!context.mounted) return;
      
      // Close loading dialog - use rootNavigator for better reliability
      Navigator.of(context, rootNavigator: true).pop();

      // Small delay to ensure dialog transition completes
      await Future.delayed(const Duration(milliseconds: 150));

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${repo.name} linked successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      
      // Close loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      // Small delay before showing error dialog
      await Future.delayed(const Duration(milliseconds: 150));

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Link Failed'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _showCommitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CommitDialog(repo: repo),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Repository?'),
        content: Text(
          'Are you sure you want to remove "${repo.name}" from quick commit? This won\'t delete the actual repository.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(gitReposRepositoryProvider).deleteRepo(repo.id);
              if (!dialogContext.mounted) return;
              Navigator.pop(dialogContext);
              
              // Small delay to ensure dialog is fully closed
              await Future.delayed(const Duration(milliseconds: 100));
              
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Repository removed')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

