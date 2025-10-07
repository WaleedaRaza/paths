import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme.dart';
import '../../../../core/models/milestone.dart';
import '../../../../core/models/goal.dart';
import '../../../../core/database/tables.dart';
import '../../../../shared/widgets/domain_metadata/domain_metadata_widget.dart';
import '../../providers/milestones_repository.dart';
import '../../providers/milestone_stats_provider.dart';
import '../../../goals/providers/goals_provider.dart';
import '../milestone_detail_page.dart';
import 'milestone_modal.dart';

enum MilestoneCardExpansion { collapsed, preview, expanded }

class MilestoneCard extends ConsumerStatefulWidget {
  final Milestone milestone;

  const MilestoneCard({super.key, required this.milestone});

  @override
  ConsumerState<MilestoneCard> createState() => _MilestoneCardState();
}

class _MilestoneCardState extends ConsumerState<MilestoneCard> {
  MilestoneCardExpansion _expansion = MilestoneCardExpansion.collapsed;

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(milestonesRepositoryProvider);
    final statsAsync = ref.watch(milestoneStatsProvider(widget.milestone.id));
    final goalsAsync = ref.watch(goalsByMilestoneProvider(widget.milestone.id));

    return GestureDetector(
      onTap: () {
        // Navigate to detail page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MilestoneDetailPage(milestoneId: widget.milestone.id),
          ),
        );
      },
      onLongPress: () {
        // Long press for inline expansion
        if (_expansion == MilestoneCardExpansion.collapsed) {
          setState(() => _expansion = MilestoneCardExpansion.preview);
        } else if (_expansion == MilestoneCardExpansion.preview) {
          setState(() => _expansion = MilestoneCardExpansion.collapsed);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        constraints: BoxConstraints(
          maxHeight: _expansion == MilestoneCardExpansion.expanded 
              ? 600 
              : _expansion == MilestoneCardExpansion.preview
                  ? 450
                  : 250,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.milestone.isCompleted
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _expansion != MilestoneCardExpansion.collapsed
                ? AppColors.primary.withOpacity(0.5)
                : widget.milestone.isCompleted
                    ? AppColors.primary.withOpacity(0.3)
                    : AppColors.border,
            width: _expansion != MilestoneCardExpansion.collapsed ? 2 : 1.5,
          ),
          boxShadow: _expansion != MilestoneCardExpansion.collapsed
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Header with Domain Badge + Status
            _buildHeader(),
            
            const SizedBox(height: 12),
            
            // Title
            _buildTitle(),
            
            const SizedBox(height: 12),
            
            // Rich Progress Bar with %
            statsAsync.when(
              data: (stats) => _buildProgressSection(stats),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            
            const SizedBox(height: 12),
            
            // Stats Rollup (domain-aware)
            statsAsync.when(
              data: (stats) => _buildStatsRollup(stats),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            
            const SizedBox(height: 12),
            
            // Domain Metadata Preview (compact mode)
            if (widget.milestone.metadata != null && widget.milestone.metadata!.isNotEmpty)
              DomainMetadataWidget(
                domain: widget.milestone.domain,
                metadataJson: widget.milestone.metadata,
                compact: true,
              ),
            
            // Inline Goal Preview (shows first 3 goals when in preview mode)
            if (_expansion != MilestoneCardExpansion.collapsed) ...[
              const SizedBox(height: 16),
              goalsAsync.when(
                data: (goals) => _buildGoalList(goals),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Text('Error loading goals'),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Bottom Row: Deadline + Points + Quick Actions
            _buildBottomRow(),
            
            // Quick Action Bar (only in preview/expanded mode)
            if (_expansion != MilestoneCardExpansion.collapsed) ...[
              const SizedBox(height: 12),
              _buildQuickActions(),
            ],
          ],
        ),
      ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.95, 0.95), duration: 300.ms);
  }

  Widget _buildHeader() {
    final status = _getMilestoneStatus();
    final statusColor = _getStatusColor(status);
    
    return Row(
      children: [
        // Domain Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _getDomainColor().withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getDomainColor().withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getDomainIcon(),
                size: 14,
                color: _getDomainColor(),
              ),
              const SizedBox(width: 6),
              Text(
                _getDomainLabel(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _getDomainColor(),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Status Indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ),
        
        const Spacer(),
        
        // Expand/Collapse icon
        Icon(
          _expansion == MilestoneCardExpansion.collapsed
              ? LucideIcons.chevronDown
              : LucideIcons.chevronUp,
          size: 18,
          color: AppColors.textTertiary,
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.milestone.title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: widget.milestone.isCompleted
            ? AppColors.textTertiary
            : AppColors.textPrimary,
        decoration: widget.milestone.isCompleted
            ? TextDecoration.lineThrough
            : TextDecoration.none,
        height: 1.2,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProgressSection(MilestoneStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(stats.progress * 100).toStringAsFixed(0)}% Complete',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${stats.completedGoals + stats.completedTasks} / ${stats.totalGoals + stats.totalTasks} items',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: stats.progress,
            backgroundColor: AppColors.border.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              stats.progress > 0.8
                  ? Colors.green
                  : stats.progress > 0.5
                      ? AppColors.accent
                      : AppColors.primary,
            ),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRollup(MilestoneStats stats) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _buildStatBadge(
          icon: LucideIcons.target,
          label: '${stats.totalGoals} goals',
          value: '${stats.completedGoals} done',
          color: AppColors.secondary,
        ),
        _buildStatBadge(
          icon: LucideIcons.listChecks,
          label: '${stats.totalTasks} tasks',
          value: '${stats.completedTasks} done',
          color: AppColors.primary,
        ),
        if (widget.milestone.domain == Domain.school && widget.milestone.metadata != null)
          _buildStatBadge(
            icon: LucideIcons.graduationCap,
            label: _getSchoolCredits(),
            value: '',
            color: AppColors.accent,
          ),
      ],
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          if (value.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(
              '• $value',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGoalList(List<Goal> goals) {
    if (goals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(LucideIcons.target, size: 16, color: AppColors.textTertiary),
            SizedBox(width: 8),
            Text(
              'No goals yet',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    final displayGoals = _expansion == MilestoneCardExpansion.preview
        ? goals.take(3).toList()
        : goals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Goals',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${goals.length}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
            ),
            const Spacer(),
            if (goals.length > 3 && _expansion == MilestoneCardExpansion.preview)
              TextButton(
                onPressed: () => setState(() => _expansion = MilestoneCardExpansion.expanded),
                child: Text(
                  '+${goals.length - 3} more',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ...displayGoals.map((goal) => _buildGoalPreviewItem(goal)),
      ],
    );
  }

  Widget _buildGoalPreviewItem(Goal goal) {
    // Mock progress for demo (in real app, would fetch from provider)
    final progress = 0.65;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Checkbox
          Icon(
            goal.isCompleted ? LucideIcons.check : LucideIcons.circle,
            size: 18,
            color: goal.isCompleted ? AppColors.secondary : AppColors.textTertiary,
          ),
          const SizedBox(width: 10),
          
          // Goal info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: goal.isCompleted
                        ? AppColors.textTertiary
                        : AppColors.textPrimary,
                    decoration: goal.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.border.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Quick navigate icon
          const Icon(
            LucideIcons.chevronRight,
            size: 16,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        // Deadline
        if (widget.milestone.deadline != null) ...[
          Icon(
            LucideIcons.calendar,
            size: 14,
            color: _isOverdue(widget.milestone.deadline!)
                ? AppColors.error
                : AppColors.textTertiary,
          ),
          const SizedBox(width: 4),
          Text(
            DateFormat('MMM d, y').format(widget.milestone.deadline!),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _isOverdue(widget.milestone.deadline!)
                  ? AppColors.error
                  : AppColors.textTertiary,
            ),
          ),
          if (_isOverdue(widget.milestone.deadline!)) ...[
            const SizedBox(width: 4),
            Text(
              '(${_getDaysOverdue()} days overdue)',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
        
        const Spacer(),
        
        // Points Badge
        if (widget.milestone.totalPoints > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.2),
                  AppColors.accent.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.zap,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.milestone.totalPoints} pts',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: LucideIcons.eye,
            label: 'View Full',
            onTap: () => _showMilestoneModal(context, widget.milestone.id),
          ),
          Container(width: 1, height: 20, color: AppColors.border),
          _buildActionButton(
            icon: LucideIcons.target,
            label: 'Add Goal',
            onTap: () {
              // TODO: Open add goal modal
            },
          ),
          Container(width: 1, height: 20, color: AppColors.border),
          _buildActionButton(
            icon: LucideIcons.pencil,
            label: 'Edit',
            onTap: () => _showMilestoneModal(context, widget.milestone.id),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  String _getMilestoneStatus() {
    if (widget.milestone.isCompleted) return 'Complete';
    if (widget.milestone.deadline != null && _isOverdue(widget.milestone.deadline!)) {
      return 'Overdue';
    }
    return 'On Track';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Complete':
        return Colors.green;
      case 'Overdue':
        return AppColors.error;
      default:
        return AppColors.accent;
    }
  }

  IconData _getDomainIcon() {
    switch (widget.milestone.domain) {
      case Domain.school:
        return LucideIcons.graduationCap;
      case Domain.projects:
        return LucideIcons.code;
      case Domain.finance:
        return LucideIcons.dollarSign;
      case Domain.health:
        return LucideIcons.heart;
      case Domain.dsa:
        return LucideIcons.brainCircuit;
      case Domain.personal:
        return LucideIcons.user;
    }
  }

  Color _getDomainColor() {
    switch (widget.milestone.domain) {
      case Domain.school:
        return const Color(0xFF6366F1); // Indigo
      case Domain.projects:
        return const Color(0xFF10B981); // Emerald
      case Domain.finance:
        return const Color(0xFFF59E0B); // Amber
      case Domain.health:
        return const Color(0xFFEF4444); // Red
      case Domain.dsa:
        return const Color(0xFF8B5CF6); // Purple
      case Domain.personal:
        return const Color(0xFF06B6D4); // Cyan
    }
  }

  String _getDomainLabel() {
    return widget.milestone.domain.name.toUpperCase();
  }

  String _getSchoolCredits() {
    // Parse metadata to get total credits (mock for now)
    return '12 CUs';
  }

  bool _isOverdue(DateTime deadline) {
    return deadline.isBefore(DateTime.now()) && !widget.milestone.isCompleted;
  }

  int _getDaysOverdue() {
    if (widget.milestone.deadline == null) return 0;
    return DateTime.now().difference(widget.milestone.deadline!).inDays;
  }

  void _showMilestoneModal(BuildContext context, String milestoneId) {
    showDialog(
      context: context,
      builder: (context) => MilestoneModal(milestoneId: milestoneId),
    );
  }
}
