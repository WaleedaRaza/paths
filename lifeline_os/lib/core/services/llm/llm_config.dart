import 'package:freezed_annotation/freezed_annotation.dart';

part 'llm_config.freezed.dart';
part 'llm_config.g.dart';

/// Enum for available LLM providers
enum LLMProvider {
  local,   // Ollama (local model like llama3.1:8b)
  openai,  // OpenAI (GPT-4, GPT-3.5-turbo)
  claude,  // Anthropic Claude (Opus, Sonnet)
}

/// Configuration for LLM provider and model selection
@freezed
class LLMConfig with _$LLMConfig {
  const factory LLMConfig({
    @Default(LLMProvider.local) LLMProvider provider,
    String? apiKey,
    @Default('llama3.1:8b') String localModel,
    @Default('gpt-4') String openaiModel,
    @Default('claude-3-5-sonnet-20241022') String claudeModel,
  }) = _LLMConfig;

  factory LLMConfig.fromJson(Map<String, dynamic> json) => _$LLMConfigFromJson(json);
}

/// Extension for provider display names
extension LLMProviderDisplay on LLMProvider {
  String get displayName {
    switch (this) {
      case LLMProvider.local:
        return 'Local (Ollama)';
      case LLMProvider.openai:
        return 'OpenAI';
      case LLMProvider.claude:
        return 'Claude';
    }
  }

  String get shortName {
    switch (this) {
      case LLMProvider.local:
        return 'Ollama';
      case LLMProvider.openai:
        return 'OpenAI';
      case LLMProvider.claude:
        return 'Claude';
    }
  }

  bool get requiresApiKey {
    return this != LLMProvider.local;
  }
}
