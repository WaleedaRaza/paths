import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';
import '../../models/refinement_suggestion.dart';
import '../../models/refinement_knobs.dart';
import '../../providers/planner_provider.dart';
import '../../services/refinement_knobs_presets.dart';
import '../../services/novelty_checker.dart';

/// Chat-mode refinement panel with 3-zone layout
/// Zone 1: Current content | Zone 2: Notes+Guidance | Zone 3: Proposed content
class RefinementPanel extends ConsumerStatefulWidget {
  final String action;
  final String fieldName;
  final String sectionType;
  final String currentContent;
  final Map<String, String> sectionContext;
  final String originalIdea;
  final String userIntent;
  final Function(String) onApply;

  const RefinementPanel({
    super.key,
    required this.action,
    required this.fieldName,
    required this.sectionType,
    required this.currentContent,
    required this.sectionContext,
    required this.originalIdea,
    required this.userIntent,
    required this.onApply,
  });

  @override
  ConsumerState<RefinementPanel> createState() => _RefinementPanelState();
}

class _RefinementPanelState extends ConsumerState<RefinementPanel> {
  final List<RefinementSuggestion> _history = [];
  RefinementSuggestion? _currentSuggestion;
  bool _isGenerating = false;
  bool _showDiff = false;
  String? _error;
  final _contentController = TextEditingController();
  final _chatController = TextEditingController();
  late RefinementKnobs _currentKnobs;
  
  @override
  void initState() {
    super.initState();
    // Initialize knobs from presets
    _currentKnobs = RefinementKnobsPresets.getKnobs(
      action: widget.action,
      sectionType: widget.sectionType,
      fieldName: widget.fieldName,
      currentContent: widget.currentContent,
    );
    // Generate immediately with initial intent
    _generateSuggestion(widget.userIntent);
  }

  @override
  void dispose() {
    _contentController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  Future<void> _generateSuggestion(String intent, {RefinementKnobs? knobs}) async {
    setState(() { 
      _isGenerating = true; 
      _error = null; 
    });
    
    try {
      final service = ref.read(refinementServiceProvider);
      if (service == null) {
        throw Exception('LLM not configured');
      }

      final suggestion = await service.getRefinementSuggestion(
        action: widget.action,
        fieldName: widget.fieldName,
        currentContent: widget.currentContent,
        sectionType: widget.sectionType,
        allFieldsInSection: widget.sectionContext,
        originalIdea: widget.originalIdea,
        userIntent: intent,
        conversationHistory: _history,
        knobs: knobs ?? _currentKnobs,
      );
      
      if (mounted) {
        setState(() {
          _history.add(suggestion);
          _currentSuggestion = suggestion;
          // Join array lines into text for controller
          _contentController.text = suggestion.proposedContentLines.join('\n');
          _isGenerating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() { 
          _error = e.toString(); 
          _isGenerating = false; 
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Row(
              children: [
                // Zone 1: Current Content (30%)
                Expanded(flex: 30, child: _buildCurrentContentPanel()),
                
                // Zone 2: Notes & Guidance (25%)
                Expanded(flex: 25, child: _buildNotesPanel()),
                
                // Zone 3: Proposed Content (45%)
                Expanded(flex: 45, child: _buildProposedPanel()),
              ],
            ),
          ),
          _buildChatInput(),
          _buildActionBar(),
        ],
      ),
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
          Icon(_getActionIcon(), size: 24, color: _getActionColor()),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getActionLabel(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                widget.fieldName,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(LucideIcons.x, size: 20),
            onPressed: () => Navigator.pop(context),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentContentPanel() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(LucideIcons.fileText, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                const Text(
                  'Current',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.currentContent,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesPanel() {
    if (_isGenerating) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(right: BorderSide(color: AppColors.border)),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'AI is analyzing...',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(right: BorderSide(color: AppColors.border)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.x, size: 32, color: Colors.red.shade400),
                const SizedBox(height: 12),
                Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_currentSuggestion == null) return const SizedBox();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notes section
            Row(
              children: [
                Icon(LucideIcons.lightbulb, size: 14, color: Colors.amber.shade600),
                const SizedBox(width: 6),
                const Text(
                  'Why',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _currentSuggestion!.notes,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Guidance section
            Row(
              children: [
                Icon(LucideIcons.compass, size: 14, color: Colors.blue.shade600),
                const SizedBox(width: 6),
                const Text(
                  'Tips',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._currentSuggestion!.guidance.map((tip) {
              final cleanTip = tip.trim().replaceFirst(RegExp(r'^[-•]\s*'), '');
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        cleanTip,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            
            if (_currentSuggestion!.reasoning != null) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(LucideIcons.brain, size: 14, color: Colors.purple.shade600),
                  const SizedBox(width: 6),
                  const Text(
                    'Reasoning',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _currentSuggestion!.reasoning!,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ],
            
            // Conversation history indicator
            if (_history.length > 1) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '💬 Iteration ${_history.length} of refinement',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProposedPanel() {
    final lineCount = _currentSuggestion?.proposedContentLines.length ?? 0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.pencil, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              const Text(
                'Proposed',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              // Line count indicator
              if (_currentSuggestion != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$lineCount / ${_currentKnobs.targetCount} lines',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              // Diff toggle
              IconButton(
                icon: Icon(
                  _showDiff ? LucideIcons.eye : LucideIcons.eyeOff,
                  size: 16,
                ),
                onPressed: () => setState(() => _showDiff = !_showDiff),
                tooltip: 'Toggle diff view',
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Style chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildStyleChip(
                'Lists only',
                _currentKnobs.listOnly,
                LucideIcons.list,
                () {
                  setState(() {
                    _currentKnobs = _currentKnobs.copyWith(listOnly: !_currentKnobs.listOnly);
                  });
                  _generateSuggestion(widget.userIntent, knobs: _currentKnobs);
                },
              ),
              _buildStyleChip(
                'Add examples',
                _currentKnobs.includeExamples,
                LucideIcons.code,
                () {
                  setState(() {
                    _currentKnobs = _currentKnobs.copyWith(includeExamples: !_currentKnobs.includeExamples);
                  });
                  _generateSuggestion(widget.userIntent, knobs: _currentKnobs);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          Expanded(
            child: _showDiff 
                ? _buildDiffView()
                : TextField(
                    controller: _contentController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Edit the proposed content...',
                      hintStyle: const TextStyle(color: AppColors.textTertiary),
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
          ),
        ],
      ),
    );
  }

  Widget _buildDiffView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Before
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.minus, size: 14, color: Colors.red.shade700),
                    const SizedBox(width: 6),
                    Text(
                      'Before',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.currentContent,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.shade900,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // After
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.plus, size: 14, color: Colors.green.shade700),
                    const SizedBox(width: 6),
                    Text(
                      'After',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _contentController.text,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade900,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatController,
              enabled: !_isGenerating,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Refine further: "Make it more specific to iOS"...',
                hintStyle: const TextStyle(color: AppColors.textTertiary),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (value) => _handleChatSubmit(),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _isGenerating ? null : _handleChatSubmit,
            icon: _isGenerating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(LucideIcons.send, size: 16),
            label: const Text('Send'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _handleChatSubmit() {
    if (_chatController.text.trim().isEmpty) return;
    final intent = _chatController.text.trim();
    _chatController.clear();
    _generateSuggestion(intent);
  }

  Widget _buildActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Retry button (more different)
          if (_currentSuggestion != null && _history.length < 5)
            OutlinedButton.icon(
              icon: const Icon(LucideIcons.shuffle, size: 16),
              label: const Text('Retry (More Different)'),
              onPressed: _isGenerating ? null : () {
                final topTrigrams = NoveltyChecker.getTopTrigrams(
                  _contentController.text,
                  5,
                );
                final newKnobs = _currentKnobs.copyWith(
                  forbidPhrases: [..._currentKnobs.forbidPhrases, ...topTrigrams],
                  temperature: (_currentKnobs.temperature + 0.15).clamp(0.0, 1.0),
                  noveltyThreshold: (_currentKnobs.noveltyThreshold + 0.1).clamp(0.0, 1.0),
                );
                setState(() => _currentKnobs = newKnobs);
                _generateSuggestion(widget.userIntent, knobs: newKnobs);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.purple.shade600,
                side: BorderSide(color: Colors.purple.shade600),
              ),
            ),
          
          const Spacer(),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            icon: const Icon(LucideIcons.check, size: 18),
            label: const Text('Apply Changes'),
            onPressed: _currentSuggestion == null ? null : () {
              widget.onApply(_contentController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleChip(String label, bool isSelected, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: _isGenerating ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.background,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 12,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActionIcon() {
    switch (widget.action) {
      case 'expand':
        return LucideIcons.maximize;
      case 'regenerate':
        return LucideIcons.refreshCw;
      case 'simplify':
        return LucideIcons.minimize;
      default:
        return LucideIcons.sparkles;
    }
  }

  Color _getActionColor() {
    switch (widget.action) {
      case 'expand':
        return Colors.green.shade600;
      case 'regenerate':
        return Colors.blue.shade600;
      case 'simplify':
        return Colors.orange.shade600;
      default:
        return AppColors.primary;
    }
  }

  String _getActionLabel() {
    switch (widget.action) {
      case 'expand':
        return 'Expand Field';
      case 'regenerate':
        return 'Regenerate Field';
      case 'simplify':
        return 'Simplify Field';
      default:
        return 'Refine Field';
    }
  }
}