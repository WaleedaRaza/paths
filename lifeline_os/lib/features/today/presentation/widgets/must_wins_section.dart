import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';
import '../../providers/must_wins_provider.dart';

class MustWinsSection extends ConsumerWidget {
  final DateTime selectedDate;

  const MustWinsSection({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mustWinsAsync = ref.watch(mustWinsProvider(selectedDate));
    final repo = ref.read(mustWinsRepositoryProvider);

    return mustWinsAsync.when(
      data: (mustWins) {
        final completedCount = mustWins.where((mw) => mw.isCompleted).length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.star, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Must-Wins',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$completedCount/3',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Subtitle
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: const Text(
              'Your 3 most important wins for today',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          // Must-Win cards
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ...mustWins.asMap().entries.map((entry) {
                  final index = entry.key;
                  final mustWin = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: index < mustWins.length - 1 ? 8 : 0),
                    child: _buildMustWinCard(context, ref, repo, mustWin, index),
                  );
                }),
                // Add Must-Win button (if less than 3)
                if (mustWins.length < 3) ...[
                  if (mustWins.isNotEmpty) const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _showAddMustWinDialog(context, ref, repo, selectedDate),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.plus,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Add Must-Win',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading Must-Wins')),
    );
  }

  Widget _buildMustWinCard(BuildContext context, WidgetRef ref, MustWinsRepository repo, mustWin, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: mustWin.isCompleted 
            ? AppColors.success.withOpacity(0.05)
            : AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: mustWin.isCompleted 
              ? AppColors.success.withOpacity(0.3)
              : AppColors.primary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Checkbox
          InkWell(
            onTap: () async {
              await repo.toggleMustWin(mustWin.id, !mustWin.isCompleted);
              if (!mustWin.isCompleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎉 Must-Win completed!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: mustWin.isCompleted ? AppColors.success : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: mustWin.isCompleted 
                      ? AppColors.success 
                      : AppColors.textTertiary,
                  width: 2,
                ),
              ),
              child: mustWin.isCompleted
                  ? const Icon(
                      LucideIcons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          // Task info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mustWin.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    decoration: mustWin.isCompleted 
                        ? TextDecoration.lineThrough 
                        : null,
                  ),
                ),
                if (mustWin.isCompleted) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.check,
                        size: 12,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Delete button
          IconButton(
            icon: const Icon(LucideIcons.trash2, size: 16),
            onPressed: () async {
              await repo.deleteMustWin(mustWin.id);
            },
            color: AppColors.textTertiary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _showAddMustWinDialog(BuildContext context, WidgetRef ref, MustWinsRepository repo, DateTime date) {
    final titleController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Must-Win'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'What must you win today?',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            const Text(
              'Limit: 3 Must-Wins per day',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isNotEmpty) {
                try {
                  await repo.addMustWin(date, titleController.text.trim());
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

