import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../providers/notes_provider.dart';

class NotesPanel extends ConsumerStatefulWidget {
  const NotesPanel({super.key});

  @override
  ConsumerState<NotesPanel> createState() => _NotesPanelState();
}

class _NotesPanelState extends ConsumerState<NotesPanel> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  DateTime? _lastSaved;
  bool _hasUnsavedChanges = false;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged(String value) {
    setState(() => _hasUnsavedChanges = true);
    
    // Cancel previous timer
    _debounce?.cancel();
    
    // Start new timer (300ms debounce)
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        await ref.read(updateEntryProvider)(value);
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
    final entryAsync = ref.watch(todayEntryProvider);
    final selectedDate = ref.watch(notesDateProvider);
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(left: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(selectedDate),

          // Journal entry
          Expanded(
            child: entryAsync.when(
              data: (entry) {
                // Update controller if content changed from elsewhere
                if (entry != null && _controller.text != entry.content) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _controller.text = entry.content;
                  });
                }
                
                return _buildJournalInput();
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Error loading entry: $err'),
              ),
            ),
          ),

          // Footer with save status
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader(DateTime date) {
    final dateStr = DateFormat('EEEE, MMM d').format(date);
    final isToday = date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.bookOpen,
                size: 18,
                color: AppColors.accent,
              ),
              const SizedBox(width: 8),
              const Text(
                'Journal',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isToday ? 'Today • $dateStr' : dateStr,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
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
          fontSize: 14,
          color: AppColors.textPrimary,
          height: 1.6,
        ),
        decoration: InputDecoration(
          hintText: 'Write your thoughts, reflections, learnings...\n\nThis auto-saves as you type.',
          hintStyle: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 13,
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

  Widget _buildFooter() {
    String statusText;
    Color statusColor;
    
    if (_hasUnsavedChanges) {
      statusText = 'Saving...';
      statusColor = AppColors.accent;
    } else if (_lastSaved != null) {
      final now = DateTime.now();
      final diff = now.difference(_lastSaved!);
      
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
            style: TextStyle(
              fontSize: 11,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
