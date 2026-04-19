import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../app/theme.dart';
import '../../../../core/database/database.dart';
import '../../providers/planner_provider.dart';
import '../../repositories/planner_repository.dart';
import '../../services/export_generator.dart';

class ExportDialogEnhanced extends ConsumerStatefulWidget {
  const ExportDialogEnhanced({super.key});

  @override
  ConsumerState<ExportDialogEnhanced> createState() => _ExportDialogEnhancedState();
}

class _ExportDialogEnhancedState extends ConsumerState<ExportDialogEnhanced> {
  String _granularity = 'section'; // 'section' | 'multiple'
  String? _selectedSection;
  String _previewContent = '';
  
  final Map<String, bool> _selectedSections = {
    'info': true,
    'research': true,
    'architecture': true,
    'features': true,
    'labor': true,
  };

  final Map<String, String> _sectionNames = {
    'info': 'Project Info',
    'research': 'Research & Stack',
    'architecture': 'Technical Architecture',
    'features': 'Feature Breakdown',
    'labor': 'Division of Labor',
  };

  @override
  void initState() {
    super.initState();
    _updatePreview();
  }

  @override
  Widget build(BuildContext context) {
    final sectionsAsync = ref.watch(sectionsProvider);
    
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Left panel: Options
            Expanded(
              flex: 3,
              child: _buildOptionsPanel(sectionsAsync.value ?? []),
            ),
            
            // Divider
            Container(width: 1, color: AppColors.border),
            
            // Right panel: Preview
            Expanded(
              flex: 5,
              child: _buildPreviewPanel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsPanel(List<ProjectSection> sections) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.download, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                'Export Options',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Granularity selector
                const Text(
                  'Export Granularity',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                
                _buildGranularityChip('Single Section', 'section', LucideIcons.fileText),
                const SizedBox(height: 8),
                _buildGranularityChip('Multiple Sections', 'multiple', LucideIcons.layers),
                
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                
                // Conditional UI based on granularity
                if (_granularity == 'multiple') ...[
                  const Text(
                    'Select Sections',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._selectedSections.entries.map((entry) {
                    return CheckboxListTile(
                      value: entry.value,
                      onChanged: (value) {
                        setState(() {
                          _selectedSections[entry.key] = value ?? false;
                        });
                        _updatePreview();
                      },
                      title: Text(
                        _sectionNames[entry.key] ?? entry.key,
                        style: const TextStyle(fontSize: 13),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                ],
                
                if (_granularity == 'section') ...[
                  const Text(
                    'Select Section',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._sectionNames.entries.map((entry) {
                    final isSelected = _selectedSection == entry.key;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedSection = entry.key;
                          });
                          _updatePreview();
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.background,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? LucideIcons.check : LucideIcons.circle,
                                size: 16,
                                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                entry.value,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
                
              ],
            ),
          ),
        ),
        
        // Action buttons
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _canExport() ? _handleCopyToClipboard : null,
                  icon: const Icon(LucideIcons.clipboard, size: 16),
                  label: const Text('Copy to Clipboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _canExport() ? _handleSaveToFile : null,
                  icon: const Icon(LucideIcons.download, size: 16),
                  label: const Text('Save as Markdown'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewPanel() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.eye, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Preview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (_granularity == 'multiple')
                Text(
                  '${_selectedSections.values.where((v) => v).length} files',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                )
              else
                Text(
                  '${_previewContent.split('\n').length} lines',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
        ),
        
        Expanded(
          child: Container(
            color: AppColors.background,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: _granularity == 'multiple' 
                ? _buildMultipleFilesPreview()
                : SelectableText(
                    _previewContent.isEmpty ? 'Select options to preview...' : _previewContent,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'monospace',
                      color: _previewContent.isEmpty ? AppColors.textTertiary : AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGranularityChip(String label, String value, IconData icon) {
    final isSelected = _granularity == value;
    return InkWell(
      onTap: () {
        setState(() {
          _granularity = value;
          if (value == 'section' && _selectedSection == null) {
            _selectedSection = 'info';
          }
        });
        _updatePreview();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.background,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMultipleFilesPreview() {
    final selectedCount = _selectedSections.values.where((v) => v).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.info, size: 16, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$selectedCount separate markdown files will be generated',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ..._selectedSections.entries.where((e) => e.value).map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.fileText, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _sectionNames[entry.key] ?? entry.key,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ProjectName_${entry.key}.md',
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  bool _canExport() {
    if (_granularity == 'multiple') return _selectedSections.values.any((v) => v);
    if (_granularity == 'section') return _selectedSection != null;
    return false;
  }

  Future<void> _updatePreview() async {
    final planId = ref.read(currentPlanProvider);
    if (planId == null) return;
    
    final sectionsAsync = ref.read(sectionsProvider);
    final sections = sectionsAsync.value ?? [];
    
    final plan = await ref.read(plannerRepositoryProvider).getPlan(planId);
    final projectName = plan.title;
    
    String content = '';
    
    if (_granularity == 'multiple') {
      // Multi-file mode: just trigger rebuild, preview widget handles display
      setState(() {});
      return;
    } else if (_granularity == 'section' && _selectedSection != null) {
      final section = sections.where((s) => s.sectionType == _selectedSection).firstOrNull;
      if (section != null) {
        content = ExportGenerator.generateSectionReadme(
          projectName: projectName,
          sectionType: _selectedSection!,
          sectionContent: section.content,
        );
      }
    }
    
    setState(() {
      _previewContent = content;
    });
  }

  Future<void> _handleCopyToClipboard() async {
    if (_granularity == 'multiple') {
      // For multiple files, copy all content separated by file markers
      final planId = ref.read(currentPlanProvider);
      if (planId == null) return;
      
      final sectionsAsync = ref.read(sectionsProvider);
      final sections = sectionsAsync.value ?? [];
      final plan = await ref.read(plannerRepositoryProvider).getPlan(planId);
      final projectName = _sanitizeFilename(plan.title);
      
      final buffer = StringBuffer();
      for (var entry in _selectedSections.entries) {
        if (!entry.value) continue;
        final section = sections.where((s) => s.sectionType == entry.key).firstOrNull;
        if (section == null) continue;
        
        buffer.writeln('=== ${projectName}_${entry.key}.md ===');
        buffer.writeln();
        buffer.writeln(ExportGenerator.generateSectionReadme(
          projectName: plan.title,
          sectionType: entry.key,
          sectionContent: section.content,
        ));
        buffer.writeln();
        buffer.writeln('=' * 60);
        buffer.writeln();
      }
      
      await Clipboard.setData(ClipboardData(text: buffer.toString()));
    } else {
      await Clipboard.setData(ClipboardData(text: _previewContent));
    }
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard!')),
      );
    }
  }

  Future<void> _handleSaveToFile() async {
    try {
      String? outputDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select export directory',
      );

      if (outputDirectory == null) return;
      
      final planId = ref.read(currentPlanProvider);
      if (planId == null) return;
      
      final sectionsAsync = ref.read(sectionsProvider);
      final sections = sectionsAsync.value ?? [];
      final plan = await ref.read(plannerRepositoryProvider).getPlan(planId);
      final projectName = _sanitizeFilename(plan.title);
      
      int fileCount = 0;
      
      if (_granularity == 'multiple') {
        // Export multiple files
        for (var entry in _selectedSections.entries) {
          if (!entry.value) continue;
          final section = sections.where((s) => s.sectionType == entry.key).firstOrNull;
          if (section == null) continue;
          
          final content = ExportGenerator.generateSectionReadme(
            projectName: plan.title,
            sectionType: entry.key,
            sectionContent: section.content,
          );
          
          final filename = '${projectName}_${entry.key}.md';
          final file = File('$outputDirectory/$filename');
          await file.writeAsString(content);
          fileCount++;
        }
      } else if (_granularity == 'section' && _selectedSection != null) {
        // Export single file
        final filename = '${projectName}_$_selectedSection.md';
        final file = File('$outputDirectory/$filename');
        await file.writeAsString(_previewContent);
        fileCount = 1;
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exported $fileCount file${fileCount > 1 ? 's' : ''} successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }
  
  String _sanitizeFilename(String name) {
    return name
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }
}
