import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';
import '../../../../core/constants/experts.dart';
import '../../providers/prompts_provider.dart';

class PromptEditorDialog extends ConsumerStatefulWidget {
  final String expertId;

  const PromptEditorDialog({
    super.key,
    required this.expertId,
  });

  @override
  ConsumerState<PromptEditorDialog> createState() => _PromptEditorDialogState();
}

class _PromptEditorDialogState extends ConsumerState<PromptEditorDialog> {
  late TextEditingController _controller;
  bool _hasChanges = false;
  bool _isCustom = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadPrompt();
  }

  Future<void> _loadPrompt() async {
    final expert = ExpertRegistry.getById(widget.expertId);
    if (expert == null) return;

    final customPrompt = await ref.read(promptsRepositoryProvider).getPrompt(widget.expertId);
    
    if (mounted) {
      setState(() {
        if (customPrompt != null) {
          _controller.text = customPrompt.systemPrompt;
          _isCustom = customPrompt.isCustom;
        } else {
          _controller.text = expert.systemPrompt;
          _isCustom = false;
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expert = ExpertRegistry.getById(widget.expertId);
    if (expert == null) {
      return const AlertDialog(
        content: Text('Expert not found'),
      );
    }

    return AlertDialog(
      title: Row(
        children: [
          Text(expert.icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit System Prompt',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  expert.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 700,
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom indicator
            if (_isCustom)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.accent),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.sparkles, size: 12, color: AppColors.accent),
                    const SizedBox(width: 6),
                    const Text(
                      'Custom Prompt',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),

            // Prompt editor
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                onChanged: (value) {
                  setState(() => _hasChanges = true);
                },
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'monospace',
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter system prompt...',
                  hintStyle: const TextStyle(color: AppColors.textTertiary),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Character count
            Text(
              '${_controller.text.length} characters',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (_isCustom)
          TextButton.icon(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset to Default?'),
                  content: const Text('This will restore the original system prompt.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && mounted) {
                await ref.read(resetPromptProvider)(widget.expertId);
                Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Prompt reset to default')),
                  );
                }
              }
            },
            icon: const Icon(LucideIcons.refreshCw, size: 16),
            label: const Text('Reset to Default'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _hasChanges
              ? () async {
                  await ref.read(savePromptProvider)(
                    widget.expertId,
                    _controller.text.trim(),
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Prompt saved')),
                    );
                  }
                }
              : null,
          icon: const Icon(LucideIcons.save, size: 16),
          label: const Text('Save'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

