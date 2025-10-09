import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../../../core/database/database.dart';
import '../../providers/planner_provider.dart';
import 'export_dialog.dart';

class PlannerEditorViewRedesigned extends ConsumerStatefulWidget {
  const PlannerEditorViewRedesigned({super.key});

  @override
  ConsumerState<PlannerEditorViewRedesigned> createState() => _PlannerEditorViewRedesignedState();
}

class _PlannerEditorViewRedesignedState extends ConsumerState<PlannerEditorViewRedesigned> {
  final TextEditingController _editorController = TextEditingController();
  Timer? _debounce;
  bool _showPreview = false;

  final Map<String, String> _sectionTitles = {
    'info': '📋 Project Info',
    'research': '🔬 Research & Stack',
    'architecture': '🏗️ Technical Architecture',
    'features': '📱 Feature Breakdown',
    'labor': '🗂️ Division of Labor',
  };

  @override
  void dispose() {
    _editorController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onEditorChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final planId = ref.read(currentPlanProvider);
      final sectionType = ref.read(currentSectionProvider);
      
      if (planId != null) {
        await ref.read(updateSectionProvider)(planId, sectionType, value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final planId = ref.watch(currentPlanProvider);
    final sectionsAsync = ref.watch(sectionsProvider);
    final currentSectionType = ref.watch(currentSectionProvider);

    if (planId == null) {
      return const Center(child: Text('No plan selected'));
    }

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Row(
            children: [
              // Left: Section Navigator (20%)
              SizedBox(
                width: 280,
                child: _buildSectionNavigator(sectionsAsync, currentSectionType),
              ),

              Container(width: 1, color: AppColors.border),

              // Center: Markdown Editor (60%)
              Expanded(
                flex: 6,
                child: sectionsAsync.when(
                  data: (sections) => _buildEditor(sections, currentSectionType),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),

              Container(width: 1, color: AppColors.border),

              // Right: AI Actions (20%)
              SizedBox(
                width: 260,
                child: _buildAIActionsPanel(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: () {
              ref.read(currentPlanProvider.notifier).state = null;
            },
            color: AppColors.textSecondary,
            tooltip: 'Back to projects',
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Project Documentation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Last saved: ${DateFormat('h:mm a').format(DateTime.now())}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _showPreview ? LucideIcons.pencil : LucideIcons.eye,
              size: 18,
            ),
            onPressed: () {
              setState(() => _showPreview = !_showPreview);
            },
            color: _showPreview ? AppColors.primary : AppColors.textSecondary,
            tooltip: _showPreview ? 'Edit mode' : 'Preview mode',
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ExportDialog(),
              );
            },
            icon: const Icon(LucideIcons.download, size: 16),
            label: const Text('Export'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionNavigator(AsyncValue<List<ProjectSection>> sectionsAsync, String currentType) {
    return Container(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Sections',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: sectionsAsync.when(
              data: (sections) {
                final sectionMap = {for (var s in sections) s.sectionType: s};
                
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: _sectionTitles.entries.map((entry) {
                    final section = sectionMap[entry.key];
                    final isActive = currentType == entry.key;
                    final hasContent = section != null && section.content.isNotEmpty;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: InkWell(
                        onTap: () {
                          ref.read(currentSectionProvider.notifier).state = entry.key;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isActive ? AppColors.primary : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                hasContent ? LucideIcons.check : LucideIcons.circle,
                                size: 16,
                                color: hasContent ? Colors.green : AppColors.textTertiary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.value,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isActive
                                            ? AppColors.primary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    if (hasContent) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        '${section.content.split(' ').length} words',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditor(List<ProjectSection> sections, String currentType) {
    final section = sections.where((s) => s.sectionType == currentType).firstOrNull;
    
    // Update controller if content changed from DB
    if (section != null && _editorController.text != section.content) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _editorController.text = section.content;
      });
    }

    return Container(
      color: AppColors.background,
      child: _showPreview
          ? _buildMarkdownPreview(section?.content ?? '')
          : _buildMarkdownEditor(section),
    );
  }

  Widget _buildMarkdownEditor(ProjectSection? section) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _sectionTitles[ref.watch(currentSectionProvider)] ?? 'Section',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (section != null) ...[
                Text(
                  'v${section.version}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TextField(
              controller: _editorController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              onChanged: _onEditorChanged,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
                color: AppColors.textPrimary,
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText: 'Content will appear here after generation...',
                hintStyle: const TextStyle(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkdownPreview(String content) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: MarkdownBody(
        data: content.isEmpty ? '*No content yet*' : content,
        styleSheet: MarkdownStyleSheet.fromTheme(
          ThemeData.dark(),
        ).copyWith(
          p: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildAIActionsPanel() {
    final sectionsAsync = ref.watch(sectionsProvider);
    final currentSectionType = ref.watch(currentSectionProvider);
    final currentSection = sectionsAsync.value?.where((s) => s.sectionType == currentSectionType).firstOrNull;
    final hasContent = currentSection != null && currentSection.content.isNotEmpty;

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Actions',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            'Regenerate',
            LucideIcons.refreshCw,
            'Rewrite this section',
            () => _handleRegenerate(),
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            'Expand',
            LucideIcons.maximize,
            'Add more detail',
            hasContent ? () => _handleExpand() : null,
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            'Simplify',
            LucideIcons.minimize,
            'Condense to essentials',
            hasContent ? () => _handleSimplify() : null,
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            'Add Examples',
            LucideIcons.code,
            'Include code samples',
            hasContent ? () => _handleAddExamples() : null,
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegenerate() async {
    final planId = ref.read(currentPlanProvider);
    if (planId == null) return;

    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Regenerating section...')),
      );

      final plan = await ref.read(plannerRepositoryProvider).getPlan(planId);
      final sectionType = ref.read(currentSectionProvider);
      
      final newContent = await ref.read(regenerateSectionProvider)(
        sectionType,
        plan.description,
      );

      await ref.read(updateSectionProvider)(planId, sectionType, newContent);
      _editorController.text = newContent;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Section regenerated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _handleExpand() async {
    final planId = ref.read(currentPlanProvider);
    if (planId == null) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expanding section...')),
      );

      final sectionType = ref.read(currentSectionProvider);
      final currentContent = _editorController.text;
      
      final newContent = await ref.read(expandSectionProvider)(
        sectionType,
        currentContent,
      );

      await ref.read(updateSectionProvider)(planId, sectionType, newContent);
      _editorController.text = newContent;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Section expanded!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _handleSimplify() async {
    final planId = ref.read(currentPlanProvider);
    if (planId == null) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Simplifying section...')),
      );

      final sectionType = ref.read(currentSectionProvider);
      final currentContent = _editorController.text;
      
      final newContent = await ref.read(simplifySectionProvider)(
        sectionType,
        currentContent,
      );

      await ref.read(updateSectionProvider)(planId, sectionType, newContent);
      _editorController.text = newContent;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Section simplified!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _handleAddExamples() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Examples feature coming soon!')),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    String description,
    VoidCallback? onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              description,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.all(12),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}

