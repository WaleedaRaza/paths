import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../models/git_repo_config.dart';
import '../../providers/git_repos_provider.dart';

class CommitDialog extends ConsumerStatefulWidget {
  final GitRepoConfig repo;

  const CommitDialog({super.key, required this.repo});

  @override
  ConsumerState<CommitDialog> createState() => _CommitDialogState();
}

class _CommitDialogState extends ConsumerState<CommitDialog> {
  final _messageController = TextEditingController();
  bool _isCommitting = false;
  String? _error;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timestamp = DateTime.now().toIso8601String();
    final previewMessage = _messageController.text.isEmpty
        ? '[timestamp]'
        : '${_messageController.text} [$timestamp]';

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(
        'Commit & Push: ${widget.repo.name}',
        style: const TextStyle(color: AppColors.textPrimary),
      ),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Commit message input
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Commit Message',
                hintText: 'Update files',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 3,
              minLines: 1,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Preview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Will commit as:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    previewMessage,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),

            // Error display
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCommitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isCommitting || _messageController.text.trim().isEmpty
              ? null
              : _commitAndPush,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: _isCommitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Commit & Push'),
        ),
      ],
    );
  }

  Future<void> _commitAndPush() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _isCommitting = true;
      _error = null;
    });

    try {
      await ref.read(quickCommitProvider)(widget.repo, message);

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.repo.name} committed and pushed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isCommitting = false;
        _error = e.toString();
      });
    }
  }
}

