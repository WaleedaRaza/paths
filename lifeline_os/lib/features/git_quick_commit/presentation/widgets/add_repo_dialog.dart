import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../app/theme.dart';
import '../../providers/git_repos_provider.dart';

class AddRepoDialog extends ConsumerStatefulWidget {
  const AddRepoDialog({super.key});

  @override
  ConsumerState<AddRepoDialog> createState() => _AddRepoDialogState();
}

class _AddRepoDialogState extends ConsumerState<AddRepoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _tokenController = TextEditingController();
  String? _localPath;
  String _authMethod = 'ssh'; // 'ssh' or 'token'
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text(
        'Add Repository',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Repo Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Repository Name',
                    hintText: 'My Project',
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: AppColors.textPrimary),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // GitHub URL
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'GitHub URL',
                    hintText: 'https://github.com/user/repo.git',
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: AppColors.textPrimary),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a GitHub URL';
                    }
                    if (!value.contains('github.com')) {
                      return 'Please enter a valid GitHub URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Local Path
                const Text(
                  'Local Path',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickFolder,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.folder,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _localPath ?? 'Choose folder...',
                            style: TextStyle(
                              color: _localPath != null
                                  ? AppColors.textPrimary
                                  : AppColors.textTertiary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_localPath == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 4, left: 4),
                    child: Text(
                      'Please select a folder',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Auth Method
                const Text(
                  'Authentication Method',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        value: 'ssh',
                        groupValue: _authMethod,
                        onChanged: (value) {
                          setState(() => _authMethod = value!);
                        },
                        title: const Text(
                          'SSH',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        dense: true,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        value: 'token',
                        groupValue: _authMethod,
                        onChanged: (value) {
                          setState(() => _authMethod = value!);
                        },
                        title: const Text(
                          'Token',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        dense: true,
                      ),
                    ),
                  ],
                ),

                // Token field (only shown if token auth selected)
                if (_authMethod == 'token') ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      labelText: 'GitHub Personal Access Token',
                      hintText: 'ghp_...',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: AppColors.textPrimary),
                    obscureText: true,
                    validator: (value) {
                      if (_authMethod == 'token' &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Please enter a token';
                      }
                      return null;
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveRepo,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _pickFolder() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      setState(() => _localPath = result);
    }
  }

  Future<void> _saveRepo() async {
    if (!_formKey.currentState!.validate() || _localPath == null) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref.read(gitReposRepositoryProvider).createRepo(
            name: _nameController.text.trim(),
            githubUrl: _urlController.text.trim(),
            localPath: _localPath!,
            authMethod: _authMethod,
            token: _authMethod == 'token' ? _tokenController.text.trim() : null,
          );

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Repository added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _isSaving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

