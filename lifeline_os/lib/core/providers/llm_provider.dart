import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:langchain/langchain.dart';
import '../services/llm/llm_config.dart';
import '../services/llm/llm_factory.dart';

// Storage keys
const _keyOpenAI = 'llm_api_key_openai';
const _keyClaude = 'llm_api_key_claude';
const _keyConfig = 'llm_config';

/// Provider for OpenAI API key (secure storage)
final openaiApiKeyProvider = StateNotifierProvider<ApiKeyNotifier, String?>((ref) {
  return ApiKeyNotifier(_keyOpenAI);
});

/// Provider for Claude API key (secure storage)
final claudeApiKeyProvider = StateNotifierProvider<ApiKeyNotifier, String?>((ref) {
  return ApiKeyNotifier(_keyClaude);
});

/// Provider for LLM configuration
final llmConfigProvider = StateNotifierProvider<LLMConfigNotifier, AsyncValue<LLMConfig>>((ref) {
  return LLMConfigNotifier(ref);
});

/// Provider for the active LLM instance
final activeLLMProvider = Provider<BaseChatModel?>((ref) {
  final configAsync = ref.watch(llmConfigProvider);
  
  return configAsync.when(
    data: (config) {
      try {
        return LLMFactory.createLLM(config);
      } catch (e) {
        // Return null if LLM creation fails (e.g., missing API key)
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// StateNotifier for managing API keys in secure storage
class ApiKeyNotifier extends StateNotifier<String?> {
  final String storageKey;

  ApiKeyNotifier(this.storageKey) : super(null) {
    _loadKey();
  }

  Future<void> _loadKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = prefs.getString(storageKey);
      state = key;
    } catch (e) {
      print('Error loading API key: $e');
      state = null;
    }
  }

  Future<void> setKey(String? key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (key == null || key.isEmpty) {
        await prefs.remove(storageKey);
        state = null;
      } else {
        await prefs.setString(storageKey, key);
        state = key;
      }
    } catch (e) {
      print('Error saving API key: $e');
      throw Exception('Failed to save API key');
    }
  }

  Future<void> clearKey() async {
    await setKey(null);
  }
}

/// StateNotifier for managing LLM configuration
class LLMConfigNotifier extends StateNotifier<AsyncValue<LLMConfig>> {
  final Ref ref;

  LLMConfigNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load saved config
      final configJson = prefs.getString(_keyConfig);
      final LLMConfig config;
      
      if (configJson != null) {
        config = LLMConfig.fromJson(jsonDecode(configJson));
      } else {
        // Default config
        config = const LLMConfig();
      }

      // Load API keys
      final openaiKey = prefs.getString(_keyOpenAI);
      final claudeKey = prefs.getString(_keyClaude);

      // Update config with loaded API keys
      final updatedConfig = config.copyWith(
        apiKey: _getApiKeyForProvider(config.provider, openaiKey, claudeKey),
      );

      state = AsyncValue.data(updatedConfig);
    } catch (e) {
      print('Error loading LLM config: $e');
      state = AsyncValue.data(const LLMConfig()); // Fallback to default
    }
  }

  String? _getApiKeyForProvider(LLMProvider provider, String? openaiKey, String? claudeKey) {
    switch (provider) {
      case LLMProvider.local:
        return null;
      case LLMProvider.openai:
        return openaiKey;
      case LLMProvider.claude:
        return claudeKey;
    }
  }

  Future<void> updateConfig(LLMConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyConfig, jsonEncode(config.toJson()));
      state = AsyncValue.data(config);
    } catch (e) {
      print('Error saving LLM config: $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> setProvider(LLMProvider provider) async {
    final currentConfig = state.valueOrNull ?? const LLMConfig();
    final prefs = await SharedPreferences.getInstance();
    
    // Load appropriate API key
    String? apiKey;
    if (provider == LLMProvider.openai) {
      apiKey = prefs.getString(_keyOpenAI);
    } else if (provider == LLMProvider.claude) {
      apiKey = prefs.getString(_keyClaude);
    }

    final newConfig = currentConfig.copyWith(
      provider: provider,
      apiKey: apiKey,
    );

    await updateConfig(newConfig);
  }

  Future<void> setModel(String model) async {
    final currentConfig = state.valueOrNull ?? const LLMConfig();
    
    final newConfig = switch (currentConfig.provider) {
      LLMProvider.local => currentConfig.copyWith(localModel: model),
      LLMProvider.openai => currentConfig.copyWith(openaiModel: model),
      LLMProvider.claude => currentConfig.copyWith(claudeModel: model),
    };

    await updateConfig(newConfig);
  }
}
