import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';
import '../../../../core/services/llm/project_chain_service.dart';

class GenerationProgressModal extends StatefulWidget {
  final Stream<GenerationProgress> progressStream;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  const GenerationProgressModal({
    super.key,
    required this.progressStream,
    required this.onComplete,
    required this.onCancel,
  });

  @override
  State<GenerationProgressModal> createState() => _GenerationProgressModalState();
}

class _GenerationProgressModalState extends State<GenerationProgressModal> {
  final List<String> _steps = [
    'Analyzing project idea',
    'Researching tech stack',
    'Designing architecture',
    'Breaking down features',
    'Planning labor division',
  ];

  int _currentStepIndex = 0;
  double _progress = 0.0;
  String _currentStepText = 'Initializing...';
  String? _error;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _listenToProgress();
  }

  void _listenToProgress() {
    widget.progressStream.listen(
      (progress) {
        if (mounted) {
          setState(() {
            _progress = progress.progress / 100.0;
            _currentStepText = progress.step;
            
            // Update step index based on progress
            if (progress.progress >= 80) {
              _currentStepIndex = 4;
            } else if (progress.progress >= 60) {
              _currentStepIndex = 3;
            } else if (progress.progress >= 40) {
              _currentStepIndex = 2;
            } else if (progress.progress >= 20) {
              _currentStepIndex = 1;
            } else {
              _currentStepIndex = 0;
            }

            // Check if complete
            if (progress.progress >= 100 && progress.status == 'completed') {
              _isComplete = true;
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  widget.onComplete();
                }
              });
            }

            // Check for errors
            if (progress.status == 'failed') {
              _error = progress.message;
            }
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _error = error.toString();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
              Icon(
                _isComplete ? LucideIcons.check : LucideIcons.loader,
                color: _isComplete ? Colors.green : AppColors.primary,
                size: 28,
              ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isComplete ? 'Plan Generated!' : 'Generating Your Project Plan...',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Steps list
            ...List.generate(_steps.length, (index) {
              return _buildStepItem(
                index,
                _steps[index],
                index < _currentStepIndex,
                index == _currentStepIndex,
              );
            }),

            const SizedBox(height: 32),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _currentStepText,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${(_progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 8,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _error != null ? Colors.red : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),

            // Error display
            if (_error != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.x, color: Colors.red, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!_isComplete && _error == null)
                  TextButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                if (_error != null)
                  ElevatedButton(
                    onPressed: widget.onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Close'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(int index, String label, bool isComplete, bool isActive) {
    IconData icon;
    Color iconColor;

    if (isComplete) {
      icon = LucideIcons.check;
      iconColor = Colors.green;
    } else if (isActive) {
      icon = LucideIcons.loader;
      iconColor = AppColors.primary;
    } else {
      icon = LucideIcons.circle;
      iconColor = AppColors.textTertiary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isComplete || isActive
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
          if (isComplete)
            const Text(
              '✓',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

