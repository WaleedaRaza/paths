import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';
import '../../../../core/models/task.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/schedule_subtasks_provider.dart';
import '../../../tasks/providers/tasks_repository.dart';
import '../../../tasks/providers/tasks_provider.dart';
import '../../../tasks/presentation/widgets/task_modal.dart';
import '../../../tasks/services/task_cloner.dart';

class CanvasTimeline extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const CanvasTimeline({super.key, required this.selectedDate});

  @override
  ConsumerState<CanvasTimeline> createState() => _CanvasTimelineState();
}

class _CanvasTimelineState extends ConsumerState<CanvasTimeline> {
  static const double pixelsPerMinute = 3.0; // Height per minute (more spacing)
  static const int intervalMinutes = 15; // 15-minute intervals
  static const int totalMinutes = 24 * 60; // 24 hours
  
  String? _draggedItemId;
  String? _resizingItemId;
  double? _dragStartY;
  int? _originalStartMinutes;
  int? _originalDuration;
  double? _hoveredY; // Track where user is hovering during drag
  final GlobalKey _canvasKey = GlobalKey();
  final GlobalKey _scrollViewKey = GlobalKey();
  ScrollController? _scrollController;
  Timer? _autoScrollTimer;
  bool _showRealignButton = false;

  @override
  void initState() {
    super.initState();
    // Initialize scroll controller with current time position
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final initialScroll = currentMinutes * pixelsPerMinute;
    
    _scrollController = ScrollController(initialScrollOffset: initialScroll);
    _scrollController!.addListener(_handleScroll);
    _startAutoScroll();
  }

  void _handleScroll() {
    if (!mounted || !_isToday()) return;
    
    // Check if user has scrolled away from current time
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final expectedScroll = currentMinutes * pixelsPerMinute;
    final currentScroll = _scrollController?.offset ?? 0.0;
    
    // Show button if scrolled more than 2 hours away from current time
    final threshold = 120 * pixelsPerMinute; // 2 hours
    final isOffTarget = (currentScroll - expectedScroll).abs() > threshold;
    
    if (isOffTarget != _showRealignButton) {
      setState(() {
        _showRealignButton = isOffTarget;
      });
    }
  }

  @override
  void didUpdateWidget(CanvasTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-scroll to current time when date changes
    if (oldWidget.selectedDate != widget.selectedDate) {
      _scrollToCurrentTime(animate: true);
    }
  }

  void _startAutoScroll() {
    // Update scroll position every minute to keep current time at top
    _autoScrollTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted && _isToday()) {
        _scrollToCurrentTime(animate: true);
        // Force rebuild to update displayed time in header
        setState(() {});
      }
    });
  }

  bool _isToday() {
    final now = DateTime.now();
    return widget.selectedDate.year == now.year &&
           widget.selectedDate.month == now.month &&
           widget.selectedDate.day == now.day;
  }

  void _scrollToCurrentTime({required bool animate}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (_scrollController != null && _scrollController!.hasClients && mounted) {
          final now = DateTime.now();
          final currentMinutes = now.hour * 60 + now.minute;
          final scrollTo = currentMinutes * pixelsPerMinute;
          
          // Ensure we don't exceed max scroll extent
          final maxScroll = _scrollController!.position.maxScrollExtent;
          final targetScroll = scrollTo.clamp(0.0, maxScroll);
          
          if (animate) {
            _scrollController!.animateTo(
              targetScroll,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else {
            _scrollController!.jumpTo(targetScroll);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController?.removeListener(_handleScroll);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheduleAsync = ref.watch(scheduleProvider(widget.selectedDate));
    final repo = ref.read(scheduleRepositoryProvider);
    final now = DateTime.now(); // Use DateTime instead of TimeOfDay
    final currentMinute = now.hour * 60 + now.minute;

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
                const Icon(LucideIcons.clock, size: 18, color: AppColors.accent),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Timeline',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (_isToday())
                      const Text(
                        'Auto-tracking current time',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textTertiary,
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    if (_isToday())
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    if (_isToday()) const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        // Force refresh on tap
                        setState(() {});
                        _scrollToCurrentTime(animate: true);
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _formatTime(now.hour, now.minute),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Canvas Area - Scrollable timeline
          Expanded(
            child: scheduleAsync.when(
              data: (scheduleItems) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return DragTarget<Task>(
                      onWillAccept: (task) => task != null,
                      onMove: (details) {
                        // Get position relative to the scroll view viewport
                        final RenderBox? scrollBox = _scrollViewKey.currentContext?.findRenderObject() as RenderBox?;
                        if (scrollBox != null && _scrollController != null) {
                          final localPosition = scrollBox.globalToLocal(details.offset);
                          // Add scroll offset to get absolute position on timeline
                          final scrollOffset = _scrollController!.hasClients ? _scrollController!.offset : 0.0;
                          final absoluteY = localPosition.dy + scrollOffset;
                          final clampedY = absoluteY.clamp(0.0, totalMinutes * pixelsPerMinute);
                          setState(() {
                            _hoveredY = clampedY;
                          });
                        }
                      },
                      onLeave: (data) {
                        setState(() {
                          _hoveredY = null;
                        });
                      },
                      onAccept: (task) async {
                        if (_hoveredY != null) {
                          // Snap to 15-minute intervals
                          final rawMinutes = (_hoveredY! / pixelsPerMinute).round();
                          final dropMinutes = (rawMinutes / 15).round() * 15;
                          final dropHour = dropMinutes ~/ 60;
                          final dropMinute = dropMinutes % 60;
                          
                          final startTime = DateTime(
                            widget.selectedDate.year,
                            widget.selectedDate.month,
                            widget.selectedDate.day,
                            dropHour,
                            dropMinute,
                          );
                          
                          final estimatedMinutes = task.estimatedMinutes ?? 60;
                          final endTime = startTime.add(Duration(minutes: estimatedMinutes));
                          
                          await repo.addScheduleItem(
                            date: widget.selectedDate,
                            title: task.title,
                            startTime: startTime,
                            endTime: endTime,
                            taskId: task.id,
                          );
                          
                          setState(() {
                            _hoveredY = null;
                          });
                        }
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Stack(
                          children: [
                            // Timeline scroll view
                            SingleChildScrollView(
                              key: _scrollViewKey,
                              controller: _scrollController,
                              child: SizedBox(
                                height: totalMinutes * pixelsPerMinute, // Full 24-hour height (4320px at 3.0)
                                width: constraints.maxWidth,
                                child: Stack(
                                  key: _canvasKey,
                                  children: [
                                // Time grid background (full height)
                                Positioned.fill(
                                  child: _buildTimeGrid(),
                                ),
                                
                                // Current time indicator (at actual time position)
                                Positioned(
                                  top: currentMinute * pixelsPerMinute,
                                  left: 0,
                                  right: 0,
                                  child: _buildCurrentTimeIndicator(),
                                ),
                                
                                // Scheduled items with overlap detection
                                ..._buildScheduleItemsWithOverlapLayout(scheduleItems, repo, constraints.maxWidth),
                                
                                // Drop preview indicator
                                if (candidateData.isNotEmpty && _hoveredY != null && candidateData.first != null)
                                  _buildDropPreview(candidateData.first!),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Realign button - appears when scrolled away from current time
                            if (_isToday())
                              Positioned(
                                bottom: 20,
                                right: 20,
                                child: AnimatedOpacity(
                                  opacity: _showRealignButton ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: AnimatedScale(
                                    scale: _showRealignButton ? 1.0 : 0.8,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                    child: IgnorePointer(
                                      ignoring: !_showRealignButton,
                                      child: Material(
                                        elevation: 8,
                                        borderRadius: BorderRadius.circular(30),
                                        child: InkWell(
                                          onTap: () {
                                            _scrollToCurrentTime(animate: true);
                                            setState(() {
                                              _showRealignButton = false;
                                            });
                                          },
                                          borderRadius: BorderRadius.circular(30),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppColors.primary,
                                                  AppColors.primary.withOpacity(0.8),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.primary.withOpacity(0.4),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  LucideIcons.target,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  'Return to Now',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Error loading schedule')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeGrid() {
    return CustomPaint(
      size: Size.infinite,
      painter: TimeGridPainter(
        intervalMinutes: intervalMinutes,
        pixelsPerMinute: pixelsPerMinute,
      ),
    );
  }

  Widget _buildCurrentTimeIndicator() {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.5),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.6),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.9),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'NOW',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  /// Build schedule items with smart overlap layout
  List<Widget> _buildScheduleItemsWithOverlapLayout(List<dynamic> scheduleItems, ScheduleRepository repo, double width) {
    // Calculate overlap groups
    final overlaps = _calculateOverlapGroups(scheduleItems);
    
    return scheduleItems.map((item) {
      final overlap = overlaps[item.id]!;
      return _buildScheduleItem(
        item, 
        repo, 
        width,
        columnIndex: overlap['column'] as int,
        totalColumns: overlap['totalColumns'] as int,
        overlapCount: overlap['overlapCount'] as int,
      );
    }).toList();
  }

  /// Get distinct color for each column to help visually distinguish overlapping tasks
  Color _getColumnColor(int columnIndex) {
    final colors = [
      AppColors.accent,      // Default color
      AppColors.primary,     // Blue
      AppColors.secondary,   // Purple
    ];
    return colors[columnIndex % colors.length];
  }

  /// Calculate which items overlap and assign them to columns
  Map<String, Map<String, dynamic>> _calculateOverlapGroups(List<dynamic> items) {
    final result = <String, Map<String, dynamic>>{};
    
    // Sort items by start time
    final sortedItems = List.from(items)
      ..sort((a, b) {
        final aStart = a.startTime.hour * 60 + a.startTime.minute;
        final bStart = b.startTime.hour * 60 + b.startTime.minute;
        return aStart.compareTo(bStart);
      });
    
    for (int i = 0; i < sortedItems.length; i++) {
      final current = sortedItems[i];
      final currentStart = current.startTime.hour * 60 + current.startTime.minute;
      final currentEnd = current.endTime.hour * 60 + current.endTime.minute;
      
      // Find all items that overlap with this one
      final overlapping = <dynamic>[];
      for (int j = 0; j < sortedItems.length; j++) {
        if (i == j) continue;
        
        final other = sortedItems[j];
        final otherStart = other.startTime.hour * 60 + other.startTime.minute;
        final otherEnd = other.endTime.hour * 60 + other.endTime.minute;
        
        // Check if they overlap
        if (currentStart < otherEnd && currentEnd > otherStart) {
          overlapping.add(other);
        }
      }
      
      // Assign column index
      int columnIndex = 0;
      if (overlapping.isNotEmpty) {
        // Find the first available column
        final usedColumns = overlapping
            .where((item) => result.containsKey(item.id))
            .map((item) => result[item.id]!['column'] as int)
            .toSet();
        
        while (usedColumns.contains(columnIndex)) {
          columnIndex++;
        }
      }
      
      final totalColumns = overlapping.length + 1;
      
      result[current.id] = {
        'column': columnIndex,
        'totalColumns': totalColumns > 3 ? 3 : totalColumns, // Max 3 columns to keep readable
        'overlapCount': overlapping.length,
      };
    }
    
    return result;
  }

  Widget _buildScheduleItem(
    dynamic item, 
    ScheduleRepository repo, 
    double width, 
    {
      int columnIndex = 0,
      int totalColumns = 1,
      int overlapCount = 0,
    }
  ) {
    final startMinutes = item.startTime.hour * 60 + item.startTime.minute;
    final endMinutes = item.endTime.hour * 60 + item.endTime.minute;
    final duration = endMinutes - startMinutes;
    final top = startMinutes * pixelsPerMinute;
    final height = duration * pixelsPerMinute;

    final isBeingDragged = _draggedItemId == item.id;
    final isBeingResized = _resizingItemId == item.id;

    // Calculate horizontal position based on column
    final timeLabelsWidth = 70.0;
    final rightMargin = 12.0;
    final availableWidth = width - timeLabelsWidth - rightMargin;
    final columnWidth = availableWidth / totalColumns;
    final left = timeLabelsWidth + (columnIndex * columnWidth);
    final itemWidth = columnWidth - 4; // 4px gap between columns

    return Positioned(
      top: top,
      left: left,
      width: itemWidth,
      height: height,
      child: GestureDetector(
        onSecondaryTapDown: (details) {
          // Right-click context menu
          _showTimelineItemMenu(context, item, details.globalPosition);
        },
        onLongPress: () {
          // Long-press for mobile/touch
          _showTimelineItemMenu(context, item, null);
        },
        onPanStart: (details) {
          // Check if dragging resize handle or entire item
          final localY = details.localPosition.dy;
          if (localY > height - 20) {
            // Dragging resize handle
            setState(() {
              _resizingItemId = item.id;
              _dragStartY = details.globalPosition.dy;
              _originalStartMinutes = startMinutes;
              _originalDuration = duration;
            });
          } else {
            // Dragging entire item
            setState(() {
              _draggedItemId = item.id;
              _dragStartY = details.globalPosition.dy;
              _originalStartMinutes = startMinutes;
              _originalDuration = duration;
            });
          }
        },
        onPanUpdate: (details) {
          if (_resizingItemId == item.id && _dragStartY != null && _originalDuration != null) {
            // Handle resize - change duration
            final deltaY = details.globalPosition.dy - _dragStartY!;
            final deltaMinutes = (deltaY / pixelsPerMinute).round();
            final newDuration = (_originalDuration! + deltaMinutes).clamp(10, totalMinutes);
            
            // Update end time
            final newEndMinutes = (_originalStartMinutes! + newDuration).clamp(0, totalMinutes);
            final newEndHour = newEndMinutes ~/ 60;
            final newEndMinute = newEndMinutes % 60;
            
            final newEndTime = DateTime(
              widget.selectedDate.year,
              widget.selectedDate.month,
              widget.selectedDate.day,
              newEndHour,
              newEndMinute,
            );
            
            // Update in real-time (optimistic update)
            repo.updateScheduleItemTime(item.id, item.startTime, newEndTime);
          } else if (_draggedItemId == item.id && _dragStartY != null && _originalStartMinutes != null) {
            // Handle move - change start time, keep duration (snap to 15-min intervals)
            final deltaY = details.globalPosition.dy - _dragStartY!;
            final deltaMinutes = (deltaY / pixelsPerMinute).round();
            final rawNewStartMinutes = _originalStartMinutes! + deltaMinutes;
            final newStartMinutes = ((rawNewStartMinutes / 15).round() * 15).clamp(0, totalMinutes - _originalDuration!);
            final newStartHour = newStartMinutes ~/ 60;
            final newStartMinute = newStartMinutes % 60;
            
            final newStartTime = DateTime(
              widget.selectedDate.year,
              widget.selectedDate.month,
              widget.selectedDate.day,
              newStartHour,
              newStartMinute,
            );
            
            final newEndTime = newStartTime.add(Duration(minutes: _originalDuration!));
            
            // Update in real-time (optimistic update)
            repo.updateScheduleItemTime(item.id, newStartTime, newEndTime);
          }
        },
        onPanEnd: (details) async {
          if (_resizingItemId == item.id || _draggedItemId == item.id) {
            // Clear state
            setState(() {
              _resizingItemId = null;
              _draggedItemId = null;
              _dragStartY = null;
              _originalStartMinutes = null;
              _originalDuration = null;
            });
          }
        },
        child: _buildScheduleItemContent(
          item, 
          repo, 
          height, 
          isBeingDragged: isBeingDragged, 
          isBeingResized: isBeingResized,
          isOverlapping: overlapCount > 0,
          columnIndex: columnIndex,
        ),
      ),
    );
  }

  Widget _buildScheduleItemContent(
    dynamic item, 
    ScheduleRepository repo, 
    double height, 
    {
      required bool isBeingDragged, 
      required bool isBeingResized,
      bool isOverlapping = false,
      int columnIndex = 0,
    }
  ) {
    // Watch subtasks if this schedule item has a linked task
    final subtasksAsync = item.taskId != null 
        ? ref.watch(scheduleSubtasksProvider(item.id))
        : null;
    
    final subtasks = subtasksAsync?.value;
    final hasSubtasks = subtasks != null && subtasks.isNotEmpty;
    
    // Different colors for overlapping items to distinguish them
    final baseColor = item.isCompleted 
        ? AppColors.success 
        : (isOverlapping 
            ? _getColumnColor(columnIndex) 
            : AppColors.accent);
    
    final backgroundColor = item.isCompleted 
        ? AppColors.success.withOpacity(0.1)
        : baseColor.withOpacity(0.15);
    
    return MouseRegion(
      cursor: isBeingDragged ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
      child: Opacity(
        opacity: isBeingDragged || isBeingResized ? 0.6 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: baseColor,
              width: isBeingDragged || isBeingResized ? 3 : (isOverlapping ? 2.5 : 2),
            ),
            boxShadow: isBeingDragged || isBeingResized ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ] : (isOverlapping ? [
              BoxShadow(
                color: baseColor.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ] : null),
          ),
          child: Stack(
            children: [
              // Content - Height-adaptive views
              if (height < 40)
                // Ultra-compact view for very small items
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          await repo.toggleScheduleItem(item.id, !item.isCompleted);
                        },
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: item.isCompleted ? AppColors.success : Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: item.isCompleted ? AppColors.success : AppColors.textTertiary, width: 1),
                          ),
                          child: item.isCompleted ? const Icon(LucideIcons.check, size: 8, color: Colors.white) : null,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              else if (height < 60)
                // Compact view without time labels
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          await repo.toggleScheduleItem(item.id, !item.isCompleted);
                        },
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: item.isCompleted ? AppColors.success : Colors.transparent,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: item.isCompleted ? AppColors.success : AppColors.textTertiary,
                              width: 1.5,
                            ),
                          ),
                          child: item.isCompleted ? const Icon(LucideIcons.check, size: 10, color: Colors.white) : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.trash2, size: 12),
                        color: AppColors.textTertiary,
                        onPressed: () async {
                          await repo.deleteScheduleItem(item.id);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                      ),
                    ],
                  ),
                )
              else
                // Full view with all details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Checkbox
                          InkWell(
                            onTap: () async {
                              await repo.toggleScheduleItem(item.id, !item.isCompleted);
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: item.isCompleted ? AppColors.success : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: item.isCompleted ? AppColors.success : AppColors.textTertiary,
                                  width: 2,
                                ),
                              ),
                              child: item.isCompleted ? const Icon(LucideIcons.check, size: 14, color: Colors.white) : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          
                          // Title
                          Flexible(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          
                          if (height > 60)
                            LongPressDraggable<Map<String, dynamic>>(
                              data: {'type': 'schedule_item', 'item': item},
                              feedback: Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(8),
                                child: Opacity(
                                  opacity: 0.8,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                                    child: const Icon(LucideIcons.arrowRight, size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                              childWhenDragging: const SizedBox.shrink(),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.move,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(LucideIcons.gripVertical, size: 16, color: AppColors.primary),
                                ),
                              ),
                            ),
                          
                          const SizedBox(width: 4),
                          
                          // Delete button
                          IconButton(
                            icon: const Icon(LucideIcons.trash2, size: 14),
                            color: AppColors.textTertiary,
                            onPressed: () async {
                              await repo.deleteScheduleItem(item.id);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      if (height > 80) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${_formatTimeFromDateTime(item.startTime)} - ${_formatTimeFromDateTime(item.endTime)}',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (hasSubtasks) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                                ),
                                child: Text(
                                  '${subtasks!.where((s) => s.isCompleted).length}/${subtasks.length}',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                      // Subtasks list (only if height > 120px)
                      if (hasSubtasks && height > 120) ...[
                        const SizedBox(height: 8),
                        ...subtasks!.take(5).map((subtask) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  final tasksRepo = ref.read(tasksRepositoryProvider);
                                  await tasksRepo.toggleSubtask(subtask.id, !subtask.isCompleted);
                                },
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: subtask.isCompleted ? AppColors.primary.withOpacity(0.8) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                      color: subtask.isCompleted ? AppColors.primary : AppColors.textTertiary,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: subtask.isCompleted 
                                    ? const Icon(LucideIcons.check, size: 9, color: Colors.white) 
                                    : null,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  subtask.title,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                    decoration: subtask.isCompleted ? TextDecoration.lineThrough : null,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ],
                  ),
                ),
              
              // Resize handle
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 20,
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeDown,
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isBeingResized 
                              ? AppColors.primary 
                              : AppColors.textTertiary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropPreview(Task task) {
    if (_hoveredY == null) return const SizedBox.shrink();
    
    // Snap to 15-minute intervals
    final rawMinutes = (_hoveredY! / pixelsPerMinute).round();
    final dropMinutes = (rawMinutes / 15).round() * 15;
    final estimatedMinutes = task.estimatedMinutes ?? 60;
    final top = dropMinutes * pixelsPerMinute;
    final height = estimatedMinutes * pixelsPerMinute;
    
    final startHour = dropMinutes ~/ 60;
    final startMinute = dropMinutes % 60;
    final endMinutes = dropMinutes + estimatedMinutes;
    final endHour = endMinutes ~/ 60;
    final endMinute = endMinutes % 60;

    return Positioned(
      top: top,
      left: 70,
      right: 12,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.4),
              AppColors.primary.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxHeight < 20) {
                // Ultra-compact: just show title on one line
                return Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.download,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (height > 60) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${_formatTime(startHour, startMinute)} - ${_formatTime(endHour, endMinute)}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showTimelineItemMenu(BuildContext context, dynamic item, Offset? position) {
    final menuItems = <PopupMenuEntry<String>>[
      if (item.taskId != null) ...[
        const PopupMenuItem<String>(
          value: 'edit_task',
          child: Row(
            children: [
              Icon(LucideIcons.pencil, size: 16, color: AppColors.textPrimary),
              SizedBox(width: 12),
              Text('Edit Task'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'clone_task',
          child: Row(
            children: [
              Icon(LucideIcons.copy, size: 16, color: AppColors.accent),
              SizedBox(width: 12),
              Text('Clone Task'),
            ],
          ),
        ),
        const PopupMenuDivider(),
      ],
      PopupMenuItem<String>(
        value: item.isCompleted ? 'uncomplete' : 'complete',
        child: Row(
          children: [
            Icon(
              item.isCompleted ? LucideIcons.circle : LucideIcons.checkCircle,
              size: 16,
              color: item.isCompleted ? AppColors.textSecondary : AppColors.success,
            ),
            const SizedBox(width: 12),
            Text(item.isCompleted ? 'Mark Incomplete' : 'Mark Complete'),
          ],
        ),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(
        value: 'delete',
        child: Row(
          children: [
            Icon(LucideIcons.trash2, size: 16, color: Colors.red),
            SizedBox(width: 12),
            Text('Delete', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    ];

    if (position != null) {
      // Desktop: show at cursor position
      showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          position.dx,
          position.dy,
          position.dx + 1,
          position.dy + 1,
        ),
        items: menuItems,
      ).then((value) => _handleMenuAction(value, item, ref.read(scheduleRepositoryProvider)));
    } else {
      // Mobile: show bottom sheet
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (item.taskId != null) ...[
                ListTile(
                  leading: const Icon(LucideIcons.pencil, color: AppColors.textPrimary),
                  title: const Text('Edit Task'),
                  onTap: () {
                    Navigator.pop(context);
                    _handleMenuAction('edit_task', item, ref.read(scheduleRepositoryProvider));
                  },
                ),
                ListTile(
                  leading: const Icon(LucideIcons.copy, color: AppColors.accent),
                  title: const Text('Clone Task'),
                  subtitle: const Text('Create a copy for another day'),
                  onTap: () {
                    Navigator.pop(context);
                    _handleMenuAction('clone_task', item, ref.read(scheduleRepositoryProvider));
                  },
                ),
                const Divider(),
              ],
              ListTile(
                leading: Icon(
                  item.isCompleted ? LucideIcons.circle : LucideIcons.checkCircle,
                  color: item.isCompleted ? AppColors.textSecondary : AppColors.success,
                ),
                title: Text(item.isCompleted ? 'Mark Incomplete' : 'Mark Complete'),
                onTap: () {
                  Navigator.pop(context);
                  _handleMenuAction(item.isCompleted ? 'uncomplete' : 'complete', item, ref.read(scheduleRepositoryProvider));
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(LucideIcons.trash2, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _handleMenuAction('delete', item, ref.read(scheduleRepositoryProvider));
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    }
  }

  void _handleMenuAction(String? action, dynamic item, ScheduleRepository repo) async {
    if (action == null) return;

    switch (action) {
      case 'edit_task':
        if (item.taskId != null) {
          showDialog(
            context: context,
            builder: (context) => TaskModal(taskId: item.taskId),
          );
        }
        break;
      case 'clone_task':
        if (item.taskId != null) {
          await _cloneTask(item.taskId);
        }
        break;
      case 'view_task':
        // TODO: Navigate to task detail page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task detail view coming soon')),
        );
        break;
      case 'complete':
        repo.toggleScheduleItemCompletion(item.id, true);
        break;
      case 'uncomplete':
        repo.toggleScheduleItemCompletion(item.id, false);
        break;
      case 'delete':
        _confirmDelete(item, repo);
        break;
    }
  }

  Future<void> _cloneTask(String taskId) async {
    final tasksAsync = ref.read(allTasksProvider);
    final tasks = tasksAsync.value ?? [];
    final sourceTask = tasks.firstWhere((t) => t.id == taskId, orElse: () => throw Exception('Task not found'));
    
    final tasksRepo = ref.read(tasksRepositoryProvider);
    await TaskCloner.cloneTask(
      repo: tasksRepo,
      sourceTask: sourceTask,
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cloned: ${sourceTask.title}'),
          backgroundColor: AppColors.success,
          action: SnackBarAction(
            label: 'View',
            textColor: Colors.white,
            onPressed: () {
              // Navigate to tasks page
            },
          ),
        ),
      );
    }
  }

  void _confirmDelete(dynamic item, ScheduleRepository repo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Schedule Item?'),
        content: Text('Remove "${item.title}" from timeline?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              repo.deleteScheduleItem(item.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _formatTimeFromDateTime(DateTime dt) {
    return _formatTime(dt.hour, dt.minute);
  }
}

class TimeGridPainter extends CustomPainter {
  final int intervalMinutes;
  final double pixelsPerMinute;

  TimeGridPainter({
    required this.intervalMinutes,
    required this.pixelsPerMinute,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    final labelPaint = Paint()
      ..color = AppColors.textSecondary;

    final textStyle = TextStyle(
      color: AppColors.textSecondary,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );

    // Draw grid lines and labels
    for (int minutes = 0; minutes < 24 * 60; minutes += intervalMinutes) {
      final y = minutes * pixelsPerMinute;
      
      // Draw horizontal line
      canvas.drawLine(
        Offset(70, y),
        Offset(size.width, y),
        paint,
      );

      // Draw time label
      final hour = minutes ~/ 60;
      final minute = minutes % 60;
      final timeLabel = _formatTimeLabel(hour, minute);
      
      final textSpan = TextSpan(text: timeLabel, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(8, y - 6));
    }
  }

  String _formatTimeLabel(int hour, int minute) {
    // For 15-min intervals, always show minutes for clarity
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


