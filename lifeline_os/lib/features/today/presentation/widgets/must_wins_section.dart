import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';

class MustWinsSection extends StatefulWidget {
  const MustWinsSection({super.key});

  @override
  State<MustWinsSection> createState() => _MustWinsSectionState();
}

class _MustWinsSectionState extends State<MustWinsSection> {
  final List<MockMustWin> _mustWins = [
    MockMustWin(title: 'Study D426 Quiz Prep', category: 'School', isCompleted: true),
    MockMustWin(title: 'Fix Petform Auth Bug', category: 'Projects', isCompleted: false),
    MockMustWin(title: 'Morning Workout', category: 'Health', isCompleted: false),
  ];

  @override
  Widget build(BuildContext context) {
    final completedCount = _mustWins.where((mw) => mw.isCompleted).length;

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
              children: _mustWins.asMap().entries.map((entry) {
                final index = entry.key;
                final mustWin = entry.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: index < _mustWins.length - 1 ? 8 : 0),
                  child: _buildMustWinCard(mustWin, index),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMustWinCard(MockMustWin mustWin, int index) {
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
              : _getCategoryColor(mustWin.category).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Checkbox
          InkWell(
            onTap: () {
              setState(() {
                mustWin.isCompleted = !mustWin.isCompleted;
              });
              if (mustWin.isCompleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎉 Must-Win completed! +5 points'),
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(mustWin.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        mustWin.category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getCategoryColor(mustWin.category),
                        ),
                      ),
                    ),
                    if (mustWin.isCompleted) ...[
                      const SizedBox(width: 6),
                      const Text(
                        '+5 pts',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Priority indicator
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: _getCategoryColor(mustWin.category),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'School':
        return AppColors.primary;
      case 'Projects':
        return AppColors.accent;
      case 'Health':
        return AppColors.success;
      case 'Finance':
        return const Color(0xFF10B981);
      default:
        return AppColors.secondary;
    }
  }
}

class MockMustWin {
  final String title;
  final String category;
  bool isCompleted;

  MockMustWin({
    required this.title,
    required this.category,
    this.isCompleted = false,
  });
}

