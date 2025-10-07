import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class FinanceMetadataView extends StatelessWidget {
  final String metadataJson;
  final bool compact;

  const FinanceMetadataView({
    super.key,
    required this.metadataJson,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final data = jsonDecode(metadataJson) as Map<String, dynamic>;
      
      if (compact) {
        return _buildCompactView(data);
      } else {
        return _buildFullView(data);
      }
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildCompactView(Map<String, dynamic> data) {
    final current = data['currentAmount'] as num? ?? 0;
    final target = data['targetAmount'] as num? ?? 0;
    final monthly = data['monthlyTarget'] as num?;
    final progress = target > 0 ? (current / target * 100).clamp(0, 100) : 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Current/Target
          const Icon(
            Icons.account_balance_wallet,
            size: 14,
            color: AppColors.accent,
          ),
          const SizedBox(width: 6),
          Text(
            '\$${_formatAmount(current)} / \$${_formatAmount(target)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),

          // Progress
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${progress.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ),

          if (monthly != null) ...[
            const SizedBox(width: 12),
            Text(
              '\$${_formatAmount(monthly)}/mo',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFullView(Map<String, dynamic> data) {
    final goalType = data['goalType'] as String?;
    final current = data['currentAmount'] as num? ?? 0;
    final target = data['targetAmount'] as num? ?? 0;
    final monthly = data['monthlyTarget'] as num?;
    final timeline = data['timeline'] as String?;
    final plan = data['savingsPlan'] as List?;
    
    final progress = target > 0 ? (current / target).clamp(0, 1) : 0;
    final remaining = (target - current).clamp(0, double.infinity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section with big numbers
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accent.withOpacity(0.15),
                AppColors.accent.withOpacity(0.05),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Goal type badge
              if (goalType != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    goalType,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              
              const SizedBox(height: 16),

              // Big money display
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Balance',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${_formatAmount(current)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '/ \$${_formatAmount(target)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(progress * 100).toStringAsFixed(1)}% Complete',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '\$${_formatAmount(remaining)} remaining',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress.toDouble(),
                      minHeight: 12,
                      backgroundColor: AppColors.border.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation(
                        progress > 0.8
                            ? Colors.green
                            : progress > 0.5
                                ? AppColors.accent
                                : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Stats row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (monthly != null)
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.calendar_month,
                    label: 'Monthly Target',
                    value: '\$${_formatAmount(monthly)}',
                    color: AppColors.secondary,
                  ),
                ),
              if (monthly != null && timeline != null) const SizedBox(width: 12),
              if (timeline != null)
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.event,
                    label: 'Timeline',
                    value: timeline,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),

        // Savings plan breakdown
        if (plan != null && plan.isNotEmpty) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Savings Plan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ...plan.map((item) {
                  final i = item as Map<String, dynamic>;
                  final name = i['name'] as String?;
                  final amount = i['amount'] as num?;
                  final frequency = i['frequency'] as String?;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (name != null)
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              if (frequency != null)
                                Text(
                                  frequency,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (amount != null)
                          Text(
                            '\$${_formatAmount(amount)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(num amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k';
    }
    return amount.toStringAsFixed(0);
  }
}

