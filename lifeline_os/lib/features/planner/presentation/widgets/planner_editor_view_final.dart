import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../../../core/database/database.dart';
import '../../providers/planner_provider.dart';
import '../../repositories/planner_repository.dart';
import 'export_dialog_enhanced.dart';
import 'refinement_panel.dart';
import 'intent_input_dialog.dart';

class PlannerEditorViewFinal extends ConsumerStatefulWidget {
  const PlannerEditorViewFinal({super.key});

  @override
  ConsumerState<PlannerEditorViewFinal> createState() => _PlannerEditorViewFinalState();
}

class _PlannerEditorViewFinalState extends ConsumerState<PlannerEditorViewFinal> {
  final Map<String, bool> _expandedSections = {
    'info': true,
    'research': true,
    'architecture': true,
    'features': true,
    'labor': false,
  };

  // Persistent controllers for all fields
  final Map<String, TextEditingController> _fieldControllers = {};

  @override
  void dispose() {
    for (final controller in _fieldControllers.values) {
      controller.dispose();
    }
    _saveDebounce?.cancel();
    super.dispose();
  }

  // Field definitions for each section
  final Map<String, List<String>> _sectionFields = {
    'info': ['Project Name', 'One-Liner', 'Target Users', 'Core Value Prop', 'Key Differentiators'],
    'research': ['Tech Stack', 'Dependencies', 'Best Practices', 'Common Pitfalls', 'Security'],
    'architecture': ['System Overview', 'Data Models', 'API Contracts', 'Auth Strategy', 'Deployment', 'Scalability'],
    'features': ['MVP Features', 'V1 Features', 'Future Enhancements', 'Time Estimates'],
    'labor': ['Work Packages', 'Phase Timeline', 'Dependencies', 'Critical Path'],
  };

  @override
  Widget build(BuildContext context) {
    final planId = ref.watch(currentPlanProvider);
    final sectionsAsync = ref.watch(sectionsProvider);

    if (planId == null) {
      return const Center(child: Text('No plan selected'));
    }

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Row(
            children: [
              // Left panel - scrollable sections
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: sectionsAsync.when(
                    data: (sections) => _buildSections(sections),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                  ),
                ),
              ),

              // Divider
              Container(width: 1, color: AppColors.border),

              // Right panel - export preview
              SizedBox(
                width: 350,
                child: _buildPreviewPanel(),
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project Documentation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'AI-generated with editable fields',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ExportDialogEnhanced(),
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

  Widget _buildSections(List<ProjectSection> sections) {
    final sectionMap = {for (var s in sections) s.sectionType: s};

    return Column(
      children: [
        _buildSection('info', '📋 Project Info', sectionMap['info']),
        const SizedBox(height: 16),
        _buildSection('research', '🔬 Research & Stack', sectionMap['research']),
        const SizedBox(height: 16),
        _buildSection('architecture', '🏗️ Technical Architecture', sectionMap['architecture']),
        const SizedBox(height: 16),
        _buildSection('features', '📱 Feature Breakdown', sectionMap['features']),
        const SizedBox(height: 16),
        _buildSection('labor', '🗂️ Division of Labor', sectionMap['labor']),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSection(String sectionType, String title, ProjectSection? section) {
    final isExpanded = _expandedSections[sectionType] ?? false;
    final fields = _sectionFields[sectionType] ?? [];

    // Parse section content into field map
    final fieldContents = _parseContentIntoFields(section?.content ?? '', fields);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Section Header
          InkWell(
            onTap: () {
              setState(() {
                _expandedSections[sectionType] = !isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (section != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Row(
                        children: [
                          Icon(LucideIcons.check, size: 12, color: Colors.green),
                          SizedBox(width: 4),
                          Text(
                            'Generated',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Fields
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: fields.map((fieldName) {
                  final content = fieldContents[fieldName] ?? '';
                  return _buildEditableField(
                    sectionType,
                    fieldName,
                    content,
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEditableField(String sectionType, String fieldName, String content) {
    final key = '$sectionType-$fieldName';
    final controller = _fieldControllers.putIfAbsent(
      key,
      () => TextEditingController(text: content),
    );
    
    // Update text only if changed externally (from AI)
    if (controller.text != content && content.isNotEmpty) {
      controller.text = content;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 80,
              maxHeight: 400, // Max height before scrolling
            ),
            child: TextField(
              controller: controller,
              maxLines: null,
              minLines: null,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
              onChanged: (value) {
                // Auto-save field changes
                _saveField(sectionType, fieldName, value);
              },
            ),
          ),
          const SizedBox(height: 8),
          // Field actions
          Row(
            children: [
              _buildFieldAction('Expand', LucideIcons.maximize, () {
                _handleExpandField(sectionType, fieldName, content);
              }),
              const SizedBox(width: 6),
              _buildFieldAction('Regenerate', LucideIcons.refreshCw, () {
                _handleRegenerateField(sectionType, fieldName, content);
              }),
              const SizedBox(width: 6),
              _buildFieldAction('Simplify', LucideIcons.minimize, () {
                _handleSimplifyField(sectionType, fieldName, content);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldAction(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Timer? _saveDebounce;
  
  void _saveField(String sectionType, String fieldName, String value) {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), () async {
      final planId = ref.read(currentPlanProvider);
      if (planId == null) return;

      final sectionsAsync = ref.read(sectionsProvider);
      final sections = sectionsAsync.value ?? [];
      final section = sections.where((s) => s.sectionType == sectionType).firstOrNull;

      // Update the field in the content
      final updatedContent = _updateFieldInContent(
        section?.content ?? '',
        fieldName,
        value,
      );

      await ref.read(updateSectionProvider)(planId, sectionType, updatedContent);
    });
  }

  Future<void> _handleExpandField(String sectionType, String fieldName, String currentContent) async {
    final planId = ref.read(currentPlanProvider);
    if (planId == null) return;
    
    // Step 1: Show intent input dialog
    final intent = await IntentInputDialog.show(
      context,
      action: 'expand',
      fieldName: fieldName,
    );
    
    if (intent == null || !mounted) return; // User cancelled
    
    try {
      // Step 2: Gather full context
      final sectionsAsync = ref.read(sectionsProvider);
      final sections = sectionsAsync.value ?? [];
      final section = sections.firstWhere((s) => s.sectionType == sectionType, 
          orElse: () => throw Exception('Section not found'));
      final fields = _sectionFields[sectionType] ?? [];
      final allFields = _parseContentIntoFields(section.content, fields);
      final plan = await ref.read(plannerRepositoryProvider).getPlan(planId);
      
      // Step 3: Show refinement panel with intent
      if (mounted) {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.95,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          builder: (context) => Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.9,
            child: RefinementPanel(
              action: 'expand',
              fieldName: fieldName,
              sectionType: sectionType,
              currentContent: currentContent,
              sectionContext: allFields,
              originalIdea: plan.description,
              userIntent: intent,
              onApply: (newContent) {
                final key = '$sectionType-$fieldName';
                final controller = _fieldControllers[key];
                if (controller != null) {
                  controller.text = newContent;
                }
                _saveField(sectionType, fieldName, newContent);
              },
            ),
          ),
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

  Future<void> _handleRegenerateField(String sectionType, String fieldName, String currentContent) async {
    final planId = ref.read(currentPlanProvider);
    if (planId == null) return;

    // Step 1: Show intent input dialog
    final intent = await IntentInputDialog.show(
      context,
      action: 'regenerate',
      fieldName: fieldName,
    );
    
    if (intent == null || !mounted) return; // User cancelled

    try {
      // Step 2: Gather full context
      final sectionsAsync = ref.read(sectionsProvider);
      final sections = sectionsAsync.value ?? [];
      final section = sections.firstWhere((s) => s.sectionType == sectionType,
          orElse: () => throw Exception('Section not found'));
      final fields = _sectionFields[sectionType] ?? [];
      final allFields = _parseContentIntoFields(section.content, fields);
      final plan = await ref.read(plannerRepositoryProvider).getPlan(planId);
      
      // Step 3: Show refinement panel with intent
      if (mounted) {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.95,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          builder: (context) => Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.9,
            child: RefinementPanel(
              action: 'regenerate',
              fieldName: fieldName,
              sectionType: sectionType,
              currentContent: currentContent,
              sectionContext: allFields,
              originalIdea: plan.description,
              userIntent: intent,
              onApply: (newContent) {
                final key = '$sectionType-$fieldName';
                final controller = _fieldControllers[key];
                if (controller != null) {
                  controller.text = newContent;
                }
                _saveField(sectionType, fieldName, newContent);
              },
            ),
          ),
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

  Future<void> _handleSimplifyField(String sectionType, String fieldName, String currentContent) async {
    final planId = ref.read(currentPlanProvider);
    if (planId == null) return;

    // Step 1: Show intent input dialog
    final intent = await IntentInputDialog.show(
      context,
      action: 'simplify',
      fieldName: fieldName,
    );
    
    if (intent == null || !mounted) return; // User cancelled

    try {
      // Step 2: Gather full context
      final sectionsAsync = ref.read(sectionsProvider);
      final sections = sectionsAsync.value ?? [];
      final section = sections.firstWhere((s) => s.sectionType == sectionType,
          orElse: () => throw Exception('Section not found'));
      final fields = _sectionFields[sectionType] ?? [];
      final allFields = _parseContentIntoFields(section.content, fields);
      final plan = await ref.read(plannerRepositoryProvider).getPlan(planId);
      
      // Step 3: Show refinement panel with intent
      if (mounted) {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.95,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          builder: (context) => Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.9,
            child: RefinementPanel(
              action: 'simplify',
              fieldName: fieldName,
              sectionType: sectionType,
              currentContent: currentContent,
              sectionContext: allFields,
              originalIdea: plan.description,
              userIntent: intent,
              onApply: (newContent) {
                final key = '$sectionType-$fieldName';
                final controller = _fieldControllers[key];
                if (controller != null) {
                  controller.text = newContent;
                }
                _saveField(sectionType, fieldName, newContent);
              },
            ),
          ),
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

  Map<String, String> _parseContentIntoFields(String content, List<String> fieldNames) {
    final result = <String, String>{};
    
    if (content.isEmpty) {
      // No content, return empty fields
      for (final fieldName in fieldNames) {
        result[fieldName] = '';
      }
      return result;
    }
    
    // Split content by lines
    final lines = content.split('\n');
    
    for (final fieldName in fieldNames) {
      final buffer = StringBuffer();
      bool foundField = false;
      bool collectingContent = false;
      
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        final lineLower = line.toLowerCase();
        final fieldLower = fieldName.toLowerCase();
        
        // Check if this line is the field header
        if (lineLower.contains(fieldLower) && (lineLower.contains('**') || lineLower.contains('#'))) {
          foundField = true;
          collectingContent = true;
          
          // Check if content is on the same line after a colon
          final colonIndex = line.indexOf(':');
          if (colonIndex >= 0 && colonIndex < line.length - 1) {
            String sameLineContent = line.substring(colonIndex + 1).trim();
            // Remove markdown formatting
            sameLineContent = sameLineContent.replaceAll('**', '').replaceAll('*', '');
            if (sameLineContent.isNotEmpty && !sameLineContent.startsWith('[')) {
              buffer.write(sameLineContent);
              buffer.write('\n');
            }
          }
          continue;
        }
        
        // If we're collecting content for this field
        if (collectingContent) {
          final trimmed = line.trim();
          
          // Stop if we hit another field header (line with ** or starts with #)
          if (trimmed.isNotEmpty && (trimmed.startsWith('**') || trimmed.startsWith('#'))) {
            break;
          }
          
          // Skip empty lines at the start
          if (buffer.isEmpty && trimmed.isEmpty) {
            continue;
          }
          
          // Add the line
          buffer.writeln(trimmed);
        }
      }
      
      // Clean up the result
      String finalContent = buffer.toString().trim();
      
      // Remove square brackets with placeholders
      finalContent = finalContent.replaceAllMapped(RegExp(r'\[([^\]]+)\]'), (match) {
        return match.group(1) ?? '';
      });
      
      // Remove remaining markdown bold
      finalContent = finalContent.replaceAll('**', '');
      
      result[fieldName] = finalContent;
    }

    return result;
  }

  String _updateFieldInContent(String content, String fieldName, String newValue) {
    // Update or append field in markdown format
    final pattern = RegExp('\\*\\*$fieldName\\*\\*:?\\s*[^\\*]*', multiLine: true);
    
    if (pattern.hasMatch(content)) {
      return content.replaceAll(pattern, '**$fieldName**: $newValue\n\n');
    } else {
      return '$content\n\n**$fieldName**: $newValue\n\n';
    }
  }

  Widget _buildPreviewPanel() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.eye,
                size: 16,
                color: AppColors.accent,
              ),
              const SizedBox(width: 8),
              const Text(
                'EXPORT PREVIEW',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: SingleChildScrollView(
              child: Text(
                'Live preview of your exported documentation will appear here...',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const ExportDialogEnhanced(),
                );
              },
              icon: const Icon(LucideIcons.download, size: 16),
              label: const Text('Export'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

