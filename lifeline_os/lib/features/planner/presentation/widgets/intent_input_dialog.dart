import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';

/// Dialog for capturing user intent before AI refinement
/// Includes preset chips for common actions and custom text input
class IntentInputDialog extends StatefulWidget {
  final String action;
  final String fieldName;

  const IntentInputDialog({
    super.key,
    required this.action,
    required this.fieldName,
  });

  /// Shows the dialog and returns user's intent, or null if cancelled
  static Future<String?> show(
    BuildContext context, {
    required String action,
    required String fieldName,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => IntentInputDialog(
        action: action,
        fieldName: fieldName,
      ),
    );
  }

  @override
  State<IntentInputDialog> createState() => _IntentInputDialogState();
}

class _IntentInputDialogState extends State<IntentInputDialog> {
  final _intentController = TextEditingController();

  @override
  void dispose() {
    _intentController.dispose();
    super.dispose();
  }

  List<String> _getPresetChips() {
    switch (widget.action) {
      case 'expand':
        return [
          'Add examples',
          'Make more technical',
          'Add security details',
          'Show implementation steps',
        ];
      case 'regenerate':
        return [
          'Different approach',
          'More concise',
          'Focus on scalability',
          'Emphasize MVP',
        ];
      case 'simplify':
        return [
          'Only essentials',
          'Bullet points only',
          'Remove jargon',
          'High-level summary',
        ];
      default:
        return [];
    }
  }

  String _getActionVerb() {
    switch (widget.action) {
      case 'expand':
        return 'expand';
      case 'regenerate':
        return 'regenerate';
      case 'simplify':
        return 'simplify';
      default:
        return 'refine';
    }
  }

  Color _getActionColor() {
    switch (widget.action) {
      case 'expand':
        return Colors.green.shade600;
      case 'regenerate':
        return Colors.blue.shade600;
      case 'simplify':
        return Colors.orange.shade600;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                widget.action == 'expand'
                    ? LucideIcons.maximize
                    : widget.action == 'regenerate'
                        ? LucideIcons.refreshCw
                        : LucideIcons.minimize,
                color: _getActionColor(),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${_getActionVerb()[0].toUpperCase()}${_getActionVerb().substring(1)}: ${widget.fieldName}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How would you like to ${_getActionVerb()} this field?',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Preset chips
            const Text(
              'Quick actions:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _getPresetChips().map((preset) {
                return ActionChip(
                  label: Text(
                    preset,
                    style: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    _intentController.text = preset;
                    setState(() {});
                  },
                  backgroundColor: AppColors.background,
                  side: BorderSide(color: AppColors.border),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Custom input
            const Text(
              'Or enter custom instructions:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _intentController,
              maxLines: 3,
              autofocus: true,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'e.g., "Focus on mobile-first approach"',
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
                  borderSide: BorderSide(color: _getActionColor(), width: 2),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
              onSubmitted: (value) => _handleSubmit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          icon: const Icon(LucideIcons.sparkles, size: 16),
          label: const Text('Generate'),
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: _getActionColor(),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    final intent = _intentController.text.trim();
    Navigator.pop(context, intent.isEmpty ? 'Generic ${widget.action}' : intent);
  }
}
