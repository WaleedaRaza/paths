import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../../../core/constants/experts.dart';
import '../../../../core/database/database.dart';
import '../../providers/chat_provider.dart';
import '../../providers/kobayashi_provider.dart';
import 'prompt_editor_dialog.dart';
import 'kobayashi_scenario_dialog.dart';

class PersonaSidebar extends ConsumerStatefulWidget {
  final Function(String) onPersonaSelected;

  const PersonaSidebar({
    super.key,
    required this.onPersonaSelected,
  });

  @override
  ConsumerState<PersonaSidebar> createState() => _PersonaSidebarState();
}

class _PersonaSidebarState extends ConsumerState<PersonaSidebar> {
  double _expertsHeight = 320.0;

  @override
  Widget build(BuildContext context) {
    final experts = ExpertRegistry.all;
    final selectedExpertId = ref.watch(currentExpertProvider);
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
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
                const Icon(
                  LucideIcons.users,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'AI Experts',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Experts list (resizable)
          SizedBox(
            height: _expertsHeight,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: experts.length,
              itemBuilder: (context, index) {
                final expert = experts[index];
                final isSelected = selectedExpertId == expert.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: InkWell(
                    onTap: () async {
                      // If selecting Kobayashi Maru, show scenario dialog first
                      if (expert.id == 'kobayashi-maru') {
                        final result = await showDialog<Map<String, dynamic>>(
                          context: context,
                          builder: (context) => const KobayashiScenarioDialog(),
                        );
                        
                        if (result == null) return; // User cancelled
                        
                        // Create new session with scenario
                        ref.read(currentExpertProvider.notifier).state = expert.id;
                        final sessionId = await ref.read(createSessionProvider)();
                        
                        // Save scenario
                        final kobayashiRepo = ref.read(kobayashiRepositoryProvider);
                        await kobayashiRepo.createScenario(
                          sessionId: sessionId,
                          role: result['role'] as String,
                          context: result['context'] as String,
                          traits: result['traits'] as String,
                          goals: result['goals'] as String,
                          winConditions: result['winConditions'] as String?,
                        );
                        
                        // Reset filter to show only current expert's chats
                        ref.read(chatHistoryFilterProvider.notifier).state = {expert.id};
                        widget.onPersonaSelected(expert.id);
                      } else {
                        ref.read(currentExpertProvider.notifier).state = expert.id;
                        ref.read(currentSessionProvider.notifier).state = null;
                        // Reset filter to show only current expert's chats
                        ref.read(chatHistoryFilterProvider.notifier).state = {expert.id};
                        widget.onPersonaSelected(expert.id);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Icon
                          Text(
                            expert.icon,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  expert.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  expert.description,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(LucideIcons.settings, size: 16),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => PromptEditorDialog(expertId: expert.id),
                              );
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            color: isSelected ? AppColors.primary : AppColors.textTertiary,
                            tooltip: 'Edit prompt',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Resizable Divider
          _ResizableDivider(
            onDrag: (delta) {
              setState(() {
                _expertsHeight = (_expertsHeight + delta).clamp(200.0, 600.0);
              });
            },
          ),

          // Chat History Section
          _ChatHistorySection(expertId: selectedExpertId),
        ],
      ),
    );
  }
}

class _ResizableDivider extends StatelessWidget {
  final Function(double) onDrag;

  const _ResizableDivider({required this.onDrag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        onDrag(details.delta.dy);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeRow,
        child: Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border(
              top: BorderSide(color: AppColors.border),
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Center(
            child: Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatHistorySection extends ConsumerWidget {
  final String expertId;

  const _ChatHistorySection({required this.expertId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSessionsAsync = ref.watch(allSessionsProvider);
    final currentSessionId = ref.watch(currentSessionProvider);
    final selectedFilters = ref.watch(chatHistoryFilterProvider);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header with Filter
            _ChatHistoryHeader(expertId: expertId),

            // Sessions List
            Expanded(
              child: allSessionsAsync.when(
                data: (allSessions) {
                  // Filter sessions by selected experts
                  final sessions = allSessions.where((s) => 
                    selectedFilters.contains(s.expertId)
                  ).toList();
                  
                  if (sessions.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No chats yet\nStart a conversation',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final isActive = currentSessionId == session.id;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: _ChatCardWithIndicator(
                          session: session,
                          isActive: isActive,
                          onTap: () {
                            ref.read(switchToSessionProvider)(session.id);
                          },
                          onOptions: () => _showSessionOptions(context, ref, session.id),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (err, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Error loading chats',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSessionOptions(BuildContext context, WidgetRef ref, String sessionId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.pencil, size: 20),
              title: const Text('Rename Chat'),
              onTap: () async {
                Navigator.pop(context);
                _showRenameDialog(context, ref, sessionId);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.trash2, size: 20, color: Colors.red),
              title: const Text('Delete Chat', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Delete Chat?'),
                    content: const Text('This will permanently delete all messages in this conversation.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                
                if (confirmed == true) {
                  try {
                    await ref.read(deleteSessionProvider)(sessionId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Chat deleted permanently')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error deleting chat: $e')),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref, String sessionId) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Chat'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Chat title',
            hintText: 'Enter new title...',
          ),
          autofocus: true,
          onSubmitted: (value) async {
            if (value.trim().isNotEmpty) {
              Navigator.pop(context);
              await ref.read(chatRepositoryProvider).updateSessionTitle(sessionId, value.trim());
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat renamed')),
                );
              }
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context);
                await ref.read(chatRepositoryProvider).updateSessionTitle(sessionId, controller.text.trim());
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chat renamed')),
                  );
                }
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }
}

class _FilterDialog extends ConsumerWidget {
  final List<Expert> experts;

  const _FilterDialog({required this.experts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilters = ref.watch(chatHistoryFilterProvider);

    return AlertDialog(
      title: const Text('Filter Chat History'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: experts.map((expert) {
            final isSelected = selectedFilters.contains(expert.id);
            return CheckboxListTile(
              value: isSelected,
              onChanged: (value) {
                if (value == true) {
                  ref.read(chatHistoryFilterProvider.notifier).state = {
                    ...selectedFilters,
                    expert.id,
                  };
                } else {
                  final newSet = Set<String>.from(selectedFilters);
                  newSet.remove(expert.id);
                  if (newSet.isNotEmpty) {
                    ref.read(chatHistoryFilterProvider.notifier).state = newSet;
                  }
                }
              },
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(expert.icon),
                  const SizedBox(width: 8),
                  Text(
                    expert.name,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              controlAffinity: ListTileControlAffinity.leading,
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Select all
            ref.read(chatHistoryFilterProvider.notifier).state =
                experts.map((e) => e.id).toSet();
          },
          child: const Text('Select All'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

class _ChatHistoryHeader extends ConsumerWidget {
  final String expertId;

  const _ChatHistoryHeader({required this.expertId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilters = ref.watch(chatHistoryFilterProvider);
    final experts = ExpertRegistry.all;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.messageSquare,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              const Text(
                'Chat History',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) => _FilterDialog(experts: experts),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedFilters.length == 1
                          ? ExpertRegistry.getById(selectedFilters.first)?.name ?? 'Filter'
                          : '${selectedFilters.length} experts selected',
                      style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
                    ),
                  ),
                  const Icon(LucideIcons.chevronDown, size: 14, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chat card with long-press animation indicator
class _ChatCardWithIndicator extends StatefulWidget {
  final ChatSession session;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onOptions;

  const _ChatCardWithIndicator({
    required this.session,
    required this.isActive,
    required this.onTap,
    required this.onOptions,
  });

  @override
  State<_ChatCardWithIndicator> createState() => _ChatCardWithIndicatorState();
}

class _ChatCardWithIndicatorState extends State<_ChatCardWithIndicator>
    with SingleTickerProviderStateMixin {
  bool _isLongPressing = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePointerDown(PointerDownEvent event) {
    setState(() => _isLongPressing = true);
    _animationController.forward(from: 0.0);
  }

  void _handlePointerUp(PointerUpEvent event) {
    setState(() => _isLongPressing = false);
    _animationController.reset();
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    setState(() => _isLongPressing = false);
    _animationController.reset();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.month}/${date.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: () {
          setState(() => _isLongPressing = false);
          _animationController.reset();
          widget.onOptions();
        },
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                color: widget.isActive
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _isLongPressing
                      ? AppColors.primary
                      : (widget.isActive ? AppColors.primary : AppColors.border),
                  width: _isLongPressing ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        ExpertRegistry.getById(widget.session.expertId)?.icon ?? '🤖',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.session.title ?? 'New conversation',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: widget.isActive
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(widget.session.lastMessageAt),
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
                ),
              ),
              if (_isLongPressing)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _CircularProgressPainter(
                          progress: _animationController.value,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for circular progress indicator
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width - 16, 16);
    const radius = 10.0;

    // Background circle
    final bgPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Start at top
      2 * 3.14159 * progress, // Progress
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
