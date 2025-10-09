import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../providers/notes_provider.dart';

class NotesPanelRedesigned extends ConsumerStatefulWidget {
  const NotesPanelRedesigned({super.key});

  @override
  ConsumerState<NotesPanelRedesigned> createState() => _NotesPanelRedesignedState();
}

class _NotesPanelRedesignedState extends ConsumerState<NotesPanelRedesigned> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  Timer? _debounce;
  DateTime? _lastSaved;
  bool _hasUnsavedChanges = false;
  DateTime? _lastLoadedDate;
  String? _lastLoadedType;

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged(String value) {
    setState(() => _hasUnsavedChanges = true);
    
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final currentTab = ref.read(notesTabProvider);
        if (currentTab == 'journal') {
          await ref.read(updateEntryProvider)(value);
        } else {
          await ref.read(updateEntryProvider)(value, title: _titleController.text);
        }
        if (mounted) {
          setState(() {
            _lastSaved = DateTime.now();
            _hasUnsavedChanges = false;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving: $e')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(notesTabProvider);
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(left: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: _buildTabContent(currentTab),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.bookOpen,
            size: 18,
            color: AppColors.accent,
          ),
          const SizedBox(width: 8),
          const Text(
            'Reflections & Notes',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final currentTab = ref.watch(notesTabProvider);
    
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _buildTab('journal', 'Journal', LucideIcons.bookText),
          _buildTab('note', 'Notes', LucideIcons.stickyNote),
          _buildTab('idea', 'Ideas', LucideIcons.lightbulb),
        ],
      ),
    );
  }

  Widget _buildTab(String tabId, String label, IconData icon) {
    final currentTab = ref.watch(notesTabProvider);
    final isActive = currentTab == tabId;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(notesTabProvider.notifier).state = tabId;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(String tab) {
    switch (tab) {
      case 'journal':
        return _buildJournalTab();
      case 'note':
      case 'idea':
        return _buildListTab(tab);
      default:
        return const SizedBox();
    }
  }

  Widget _buildJournalTab() {
    final selectedDate = ref.watch(notesDateProvider);
    final currentTab = ref.watch(notesTabProvider);
    final entryAsync = ref.watch(currentEntryProvider);
    
    // Check if date or type changed - clear controller if so
    final dateChanged = _lastLoadedDate != null && 
        (_lastLoadedDate!.year != selectedDate.year ||
         _lastLoadedDate!.month != selectedDate.month ||
         _lastLoadedDate!.day != selectedDate.day);
    
    final typeChanged = _lastLoadedType != null && _lastLoadedType != currentTab;
    
    if (dateChanged || typeChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.clear();
        _lastSaved = null;
        _hasUnsavedChanges = false;
      });
    }
    
    _lastLoadedDate = selectedDate;
    _lastLoadedType = currentTab;
    
    return Column(
      children: [
        _buildDateNavigator(selectedDate),
        Expanded(
          child: entryAsync.when(
            data: (entry) {
              if (entry != null) {
                // Load existing entry content only if controller is empty or content differs
                if (_controller.text.isEmpty || 
                    (_controller.text != entry.content && !_hasUnsavedChanges)) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _controller.text = entry.content;
                  });
                }
                return _buildJournalInput();
              } else {
                // No entry exists - clear controller and show placeholder
                if (_controller.text.isNotEmpty && !_hasUnsavedChanges) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _controller.clear();
                  });
                }
                return _buildJournalPlaceholder(selectedDate);
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
        if (_controller.text.isNotEmpty) _buildSaveStatus(),
      ],
    );
  }

  Widget _buildJournalPlaceholder(DateTime date) {
    final dateStr = DateFormat('MMMM d, y').format(date);
    final isToday = date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.bookOpen,
              size: 48,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              isToday ? 'No entry for today yet' : 'No entry for $dateStr',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Click below to start writing',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Focus the text field by rebuilding with content
                setState(() {
                  _controller.clear();
                });
              },
              icon: const Icon(LucideIcons.penTool, size: 18),
              label: const Text('Start Writing'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateNavigator(DateTime date) {
    final dateStr = DateFormat('EEEE, MMM d, y').format(date);
    final isToday = date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(LucideIcons.chevronLeft, size: 18),
            onPressed: () {
              ref.read(notesDateProvider.notifier).state =
                  date.subtract(const Duration(days: 1));
            },
            color: AppColors.textSecondary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (isToday)
                  const Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.accent,
                    ),
                  ),
              ],
            ),
          ),
          if (!isToday)
            TextButton(
              onPressed: () {
                ref.read(notesDateProvider.notifier).state = DateTime.now();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Today',
                style: TextStyle(fontSize: 11),
              ),
            ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(LucideIcons.chevronRight, size: 18),
            onPressed: () {
              ref.read(notesDateProvider.notifier).state =
                  date.add(const Duration(days: 1));
            },
            color: AppColors.textSecondary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        onChanged: _onTextChanged,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textPrimary,
          height: 1.6,
        ),
        decoration: InputDecoration(
          hintText: 'Write your journal entry for today...\n\nReflect on what happened, lessons learned, goals achieved...',
          hintStyle: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 12,
          ),
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
    );
  }

  Widget _buildListTab(String type) {
    final entriesAsync = ref.watch(entriesByTypeProvider(type));
    
    return entriesAsync.when(
      data: (entries) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCreateButton(type);
          }
          return _buildEntryCard(entries[index - 1]);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildCreateButton(String type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton.icon(
        onPressed: () => _showCreateDialog(type),
        icon: const Icon(LucideIcons.plus, size: 16),
        label: Text('New ${type == 'note' ? 'Note' : 'Idea'}'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildEntryCard(entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: entry.title != null && entry.title!.isNotEmpty
                      ? Text(
                          entry.title!,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        )
                      : const SizedBox(),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.pencil, size: 14),
                  onPressed: () => _showEditDialog(entry),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppColors.textSecondary,
                  tooltip: 'Edit',
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 14),
                  onPressed: () => _showDeleteConfirmation(entry.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: Colors.red,
                  tooltip: 'Delete',
                ),
              ],
            ),
            if (entry.title != null && entry.title!.isNotEmpty) const SizedBox(height: 6),
            Text(
              entry.content,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMM d, y • h:mm a').format(entry.date),
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(entry) {
    showDialog(
      context: context,
      builder: (context) => _EditEntryDialog(entry: entry),
    );
  }

  void _showDeleteConfirmation(String entryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(deleteEntryProvider)(entryId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Entry deleted')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => _CreateEntryDialog(type: type),
    );
  }

  Widget _buildSaveStatus() {
    String statusText;
    Color statusColor;
    
    if (_hasUnsavedChanges) {
      statusText = 'Saving...';
      statusColor = AppColors.accent;
    } else if (_lastSaved != null) {
      final diff = DateTime.now().difference(_lastSaved!);
      if (diff.inSeconds < 60) {
        statusText = 'Saved just now';
      } else if (diff.inMinutes < 60) {
        statusText = 'Saved ${diff.inMinutes}m ago';
      } else {
        statusText = 'Saved ${DateFormat('h:mm a').format(_lastSaved!)}';
      }
      statusColor = AppColors.textTertiary;
    } else {
      statusText = 'Auto-save enabled';
      statusColor = AppColors.textTertiary;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Icon(
            _hasUnsavedChanges ? LucideIcons.loader : LucideIcons.check,
            size: 12,
            color: statusColor,
          ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(fontSize: 11, color: statusColor),
          ),
        ],
      ),
    );
  }
}

class _CreateEntryDialog extends ConsumerStatefulWidget {
  final String type;

  const _CreateEntryDialog({required this.type});

  @override
  ConsumerState<_CreateEntryDialog> createState() => _CreateEntryDialogState();
}

class _CreateEntryDialogState extends ConsumerState<_CreateEntryDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New ${widget.type == 'note' ? 'Note' : 'Idea'}'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter a title...',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Enter content...',
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_titleController.text.trim().isEmpty) return;
            
            await ref.read(createEntryProvider)(
              widget.type,
              _titleController.text.trim(),
              _contentController.text.trim(),
            );
            
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}

class _EditEntryDialog extends ConsumerStatefulWidget {
  final dynamic entry;

  const _EditEntryDialog({required this.entry});

  @override
  ConsumerState<_EditEntryDialog> createState() => _EditEntryDialogState();
}

class _EditEntryDialogState extends ConsumerState<_EditEntryDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry.title ?? '');
    _contentController = TextEditingController(text: widget.entry.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.entry.type == 'note' ? 'Note' : 'Idea'}'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter a title...',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Enter content...',
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_titleController.text.trim().isEmpty) return;
            
            // Update the entry via repository
            await ref.read(notesRepositoryProvider).updateEntry(
              widget.entry.id,
              _titleController.text.trim(),
              _contentController.text.trim(),
            );
            
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Entry updated')),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

