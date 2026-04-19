import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../app/theme.dart';
import '../../features/milestones/models/mgtst_suggestion.dart';

/// Reusable panel for displaying AI-generated suggestions with approval UI
/// 
/// Shows suggestions with checkboxes, allows regeneration, and approval
class MGTSTSuggestionPanel extends StatefulWidget {
  final MGTSTSuggestion suggestion;
  final VoidCallback onRegenerate;
  final Function(MGTSTSuggestion) onApprove;
  final VoidCallback onCancel;
  
  const MGTSTSuggestionPanel({
    super.key,
    required this.suggestion,
    required this.onRegenerate,
    required this.onApprove,
    required this.onCancel,
  });
  
  @override
  State<MGTSTSuggestionPanel> createState() => _MGTSTSuggestionPanelState();
}

class _MGTSTSuggestionPanelState extends State<MGTSTSuggestionPanel> {
  late MGTSTSuggestion _currentSuggestion;
  
  @override
  void initState() {
    super.initState();
    _currentSuggestion = widget.suggestion;
  }
  
  @override
  void didUpdateWidget(MGTSTSuggestionPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.suggestion != widget.suggestion) {
      setState(() {
        _currentSuggestion = widget.suggestion;
      });
    }
  }
  
  int get _selectedCount {
    int count = 0;
    for (final goal in _currentSuggestion.goals) {
      if (goal.selected) {
        count++;
        count += goal.tasks.where((t) => t.selected).length;
      }
    }
    return count;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with regenerate button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.sparkles, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'AI Suggestions',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: widget.onRegenerate,
                    icon: const Icon(LucideIcons.refreshCw, size: 14),
                    label: const Text('Regenerate'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _currentSuggestion.notes,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Mission suggestion
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.flag, size: 16, color: AppColors.accent),
                  const SizedBox(width: 8),
                  const Text(
                    'Mission',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _currentSuggestion.mission.suggestedTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _currentSuggestion.mission.rationale,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Goals list
        const Text(
          'Goals & Tasks',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Expanded(
          child: ListView.builder(
            itemCount: _currentSuggestion.goals.length,
            itemBuilder: (context, index) {
              final goal = _currentSuggestion.goals[index];
              return _GoalSuggestionCard(
                goal: goal,
                onToggleGoal: (selected) {
                  setState(() {
                    _currentSuggestion = _currentSuggestion.copyWith(
                      goals: _currentSuggestion.goals.map((g) {
                        if (g == goal) {
                          return g.copyWith(selected: selected);
                        }
                        return g;
                      }).toList(),
                    );
                  });
                },
                onToggleTask: (task, selected) {
                  setState(() {
                    _currentSuggestion = _currentSuggestion.copyWith(
                      goals: _currentSuggestion.goals.map((g) {
                        if (g == goal) {
                          return g.copyWith(
                            tasks: g.tasks.map((t) {
                              if (t == task) {
                                return t.copyWith(selected: selected);
                              }
                              return t;
                            }).toList(),
                          );
                        }
                        return g;
                      }).toList(),
                    );
                  });
                },
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Action buttons
        Row(
          children: [
            Text(
              '$_selectedCount items selected',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: widget.onCancel,
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _selectedCount > 0
                  ? () => widget.onApprove(_currentSuggestion)
                  : null,
              icon: const Icon(LucideIcons.check, size: 16),
              label: Text('Approve Selected ($_selectedCount)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.border,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GoalSuggestionCard extends StatefulWidget {
  final GoalSuggestion goal;
  final Function(bool) onToggleGoal;
  final Function(TaskSuggestion, bool) onToggleTask;
  
  const _GoalSuggestionCard({
    required this.goal,
    required this.onToggleGoal,
    required this.onToggleTask,
  });
  
  @override
  State<_GoalSuggestionCard> createState() => _GoalSuggestionCardState();
}

class _GoalSuggestionCardState extends State<_GoalSuggestionCard> {
  bool _isExpanded = true;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.goal.selected
              ? AppColors.primary.withOpacity(0.5)
              : AppColors.border,
          width: widget.goal.selected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Goal header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Checkbox(
                    value: widget.goal.selected,
                    onChanged: (val) => widget.onToggleGoal(val ?? false),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.goal.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.goal.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${widget.goal.tasks.length} tasks',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
          
          // Tasks list
          if (_isExpanded)
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: widget.goal.tasks.map((task) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: task.selected,
                          onChanged: (val) => widget.onToggleTask(task, val ?? false),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        Expanded(
                          child: Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        _PriorityBadge(priority: task.priority),
                        const SizedBox(width: 6),
                        _EnergyBadge(energy: task.energy),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;
  
  const _PriorityBadge({required this.priority});
  
  @override
  Widget build(BuildContext context) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'low':
        color = Colors.blue;
        break;
      default:
        color = AppColors.textTertiary;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _EnergyBadge extends StatelessWidget {
  final String energy;
  
  const _EnergyBadge({required this.energy});
  
  @override
  Widget build(BuildContext context) {
    String icon;
    switch (energy.toLowerCase()) {
      case 'high':
        icon = '🔥🔥🔥';
        break;
      case 'medium':
        icon = '🔥🔥';
        break;
      case 'low':
        icon = '🔥';
        break;
      default:
        icon = '';
    }
    
    return Text(
      icon,
      style: const TextStyle(fontSize: 10),
    );
  }
}

