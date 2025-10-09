import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../app/theme.dart';
import '../../../../core/database/database.dart';
import '../../providers/planner_provider.dart';

class ExportDialog extends ConsumerStatefulWidget {
  const ExportDialog({super.key});

  @override
  ConsumerState<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends ConsumerState<ExportDialog> {
  final Map<String, bool> _selectedSections = {
    'info': true,
    'research': true,
    'architecture': true,
    'features': true,
    'labor': true,
  };

  String _exportFormat = 'cursor'; // 'cursor' | 'multifile' | 'json'

  final Map<String, String> _sectionNames = {
    'info': 'Project Info',
    'research': 'Research & Stack',
    'architecture': 'Technical Architecture',
    'features': 'Feature Breakdown',
    'labor': 'Division of Labor',
  };

  @override
  Widget build(BuildContext context) {
    final sectionsAsync = ref.watch(sectionsProvider);

    return AlertDialog(
      title: const Text('Export Project Plan'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Sections',
              style: TextStyle(
                fontSize: 13,
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
                },
                title: Text(
                  _sectionNames[entry.key] ?? entry.key,
                  style: const TextStyle(fontSize: 13),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
              );
            }),
            const SizedBox(height: 16),
            const Text(
              'Export Format',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _exportFormat,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'cursor',
                  child: Text('Cursor Context (Single .md)'),
                ),
                DropdownMenuItem(
                  value: 'multifile',
                  child: Text('Multi-file Markdown'),
                ),
                DropdownMenuItem(
                  value: 'json',
                  child: Text('JSON (Structured Data)'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _exportFormat = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            await _handleExportToClipboard(sectionsAsync.value ?? []);
          },
          icon: const Icon(LucideIcons.clipboard, size: 16),
          label: const Text('Copy to Clipboard'),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            await _handleExportToFiles(sectionsAsync.value ?? []);
          },
          icon: const Icon(LucideIcons.download, size: 16),
          label: const Text('Save to Files'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _handleExportToClipboard(List<ProjectSection> sections) async {
    final content = _generateExport(sections);
    
    await Clipboard.setData(ClipboardData(text: content));
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard!')),
      );
    }
  }

  Future<void> _handleExportToFiles(List<ProjectSection> sections) async {
    try {
      String? outputDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select export directory',
      );

      if (outputDirectory == null) return;

      if (_exportFormat == 'multifile') {
        // Export multiple files
        for (var entry in _selectedSections.entries) {
          if (!entry.value) continue;
          
          final section = sections.where((s) => s.sectionType == entry.key).firstOrNull;
          if (section == null) continue;

          final fileName = '${_getSectionIndex(entry.key)}-${entry.key}.md';
          final file = File('$outputDirectory/$fileName');
          await file.writeAsString(section.content);
        }
      } else {
        // Export single file
        final content = _generateExport(sections);
        final extension = _exportFormat == 'json' ? 'json' : 'md';
        final file = File('$outputDirectory/project-plan.$extension');
        await file.writeAsString(content);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exported successfully!')),
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

  String _generateExport(List<ProjectSection> sections) {
    if (_exportFormat == 'json') {
      return _generateJSON(sections);
    } else {
      return _generateMarkdown(sections);
    }
  }

  String _generateMarkdown(List<ProjectSection> sections) {
    final buffer = StringBuffer();
    
    if (_exportFormat == 'cursor') {
      buffer.writeln('# Project Documentation');
      buffer.writeln('');
      buffer.writeln('Generated for Cursor AI context.');
      buffer.writeln('');
      buffer.writeln('---');
      buffer.writeln('');
    }

    for (var entry in _selectedSections.entries) {
      if (!entry.value) continue;
      
      final section = sections.where((s) => s.sectionType == entry.key).firstOrNull;
      if (section == null) continue;

      buffer.writeln('# ${_sectionNames[entry.key]}');
      buffer.writeln('');
      buffer.writeln(section.content);
      buffer.writeln('');
      buffer.writeln('---');
      buffer.writeln('');
    }

    return buffer.toString();
  }

  String _generateJSON(List<ProjectSection> sections) {
    final data = {
      'plan': {
        'exportedAt': DateTime.now().toIso8601String(),
        'format': 'json',
      },
      'sections': sections
          .where((s) => _selectedSections[s.sectionType] == true)
          .map((s) => {
                'type': s.sectionType,
                'content': s.content,
                'version': s.version,
                'updatedAt': s.updatedAt.toIso8601String(),
              })
          .toList(),
    };

    return JsonEncoder.withIndent('  ').convert(data);
  }

  String _getSectionIndex(String type) {
    final order = ['info', 'research', 'architecture', 'features', 'labor'];
    final index = order.indexOf(type) + 1;
    return index.toString().padLeft(2, '0');
  }
}

