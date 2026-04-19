import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:langchain/langchain.dart';
import '../../../../app/theme.dart';
import '../../../../core/providers/llm_provider.dart';
import '../../../../core/services/llm/llm_config.dart';
import '../../../../core/services/llm/llm_factory.dart';

class ApiKeysPanel extends ConsumerStatefulWidget {
  const ApiKeysPanel({super.key});

  @override
  ConsumerState<ApiKeysPanel> createState() => _ApiKeysPanelState();
}

class _ApiKeysPanelState extends ConsumerState<ApiKeysPanel> {
  final _openaiController = TextEditingController();
  final _claudeController = TextEditingController();
  bool _showOpenai = false;
  bool _showClaude = false;
  bool _isTestingOpenai = false;
  bool _isTestingClaude = false;

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  void _loadKeys() {
    // Load keys from providers
    Future.microtask(() {
      final openaiKey = ref.read(openaiApiKeyProvider);
      final claudeKey = ref.read(claudeApiKeyProvider);
      
      if (openaiKey != null) {
        _openaiController.text = openaiKey;
      }
      if (claudeKey != null) {
        _claudeController.text = claudeKey;
      }
    });
  }

  @override
  void dispose() {
    _openaiController.dispose();
    _claudeController.dispose();
    super.dispose();
  }

  Future<void> _saveOpenaiKey() async {
    try {
      await ref.read(openaiApiKeyProvider.notifier).setKey(_openaiController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ OpenAI API key saved securely'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to save key: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveClaudeKey() async {
    try {
      await ref.read(claudeApiKeyProvider.notifier).setKey(_claudeController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Claude API key saved securely'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to save key: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _testConnection(LLMProvider provider) async {
    setState(() {
      if (provider == LLMProvider.openai) {
        _isTestingOpenai = true;
      } else {
        _isTestingClaude = true;
      }
    });

    try {
      final config = LLMConfig(
        provider: provider,
        apiKey: provider == LLMProvider.openai
            ? _openaiController.text
            : _claudeController.text,
      );

      final llm = LLMFactory.createLLM(config);
      
      // Send a simple test prompt
      final response = await llm.invoke(
        PromptValue.string('Say "API key is valid" in exactly 4 words.'),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${provider.displayName} connection successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Connection failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          if (provider == LLMProvider.openai) {
            _isTestingOpenai = false;
          } else {
            _isTestingClaude = false;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.key, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                'API Keys',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Configure API keys for cloud AI models. Keys are stored securely.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // OpenAI API Key
          _buildKeySection(
            label: 'OpenAI API Key',
            subtitle: 'For GPT-4, GPT-3.5-turbo',
            controller: _openaiController,
            showKey: _showOpenai,
            onToggleShow: () => setState(() => _showOpenai = !_showOpenai),
            onSave: _saveOpenaiKey,
            onTest: () => _testConnection(LLMProvider.openai),
            isTesting: _isTestingOpenai,
            hasKey: ref.watch(openaiApiKeyProvider) != null,
          ),

          const SizedBox(height: 24),

          // Claude API Key
          _buildKeySection(
            label: 'Claude API Key',
            subtitle: 'For Claude Opus, Sonnet',
            controller: _claudeController,
            showKey: _showClaude,
            onToggleShow: () => setState(() => _showClaude = !_showClaude),
            onSave: _saveClaudeKey,
            onTest: () => _testConnection(LLMProvider.claude),
            isTesting: _isTestingClaude,
            hasKey: ref.watch(claudeApiKeyProvider) != null,
          ),

          const SizedBox(height: 16),
          
          // Info box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.info, size: 16, color: Colors.blue.shade400),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Get API keys from: platform.openai.com and console.anthropic.com',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeySection({
    required String label,
    required String subtitle,
    required TextEditingController controller,
    required bool showKey,
    required VoidCallback onToggleShow,
    required VoidCallback onSave,
    required VoidCallback onTest,
    required bool isTesting,
    required bool hasKey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            if (hasKey)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '✅ Saved',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: !showKey,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'monospace',
                ),
                decoration: InputDecoration(
                  hintText: 'sk-...',
                  hintStyle: TextStyle(
                    color: AppColors.textTertiary,
                    fontFamily: 'monospace',
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
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
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showKey ? LucideIcons.eyeOff : LucideIcons.eye,
                      size: 18,
                    ),
                    onPressed: onToggleShow,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text('Save'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: isTesting ? null : onTest,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                side: BorderSide(color: AppColors.border),
              ),
              child: isTesting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Test'),
            ),
          ],
        ),
      ],
    );
  }
}
