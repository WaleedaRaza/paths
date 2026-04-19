import 'package:langchain/langchain.dart';
import 'package:langchain_ollama/langchain_ollama.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'llm_config.dart';

/// Factory for creating LangChain LLM instances based on configuration
class LLMFactory {
  /// Creates a BaseChatModel instance from LLMConfig
  static BaseChatModel createLLM(LLMConfig config) {
    switch (config.provider) {
      case LLMProvider.local:
        return ChatOllama(
          defaultOptions: ChatOllamaOptions(
            model: config.localModel,
            temperature: 0.7,
          ),
        );

      case LLMProvider.openai:
        if (config.apiKey == null || config.apiKey!.isEmpty) {
          throw LLMConfigException('OpenAI API key is required but not set');
        }
        return ChatOpenAI(
          apiKey: config.apiKey!,
          defaultOptions: ChatOpenAIOptions(
            model: config.openaiModel,
            temperature: 0.7,
          ),
        );

      case LLMProvider.claude:
        if (config.apiKey == null || config.apiKey!.isEmpty) {
          throw LLMConfigException('Claude API key is required but not set');
        }
        // Note: For Claude, use ChatAnthropic from langchain_openai
        // For now, using OpenAI client with Anthropic API
        return ChatOpenAI(
          apiKey: config.apiKey!,
          baseUrl: 'https://api.anthropic.com/v1',
          defaultOptions: ChatOpenAIOptions(
            model: config.claudeModel,
            temperature: 0.7,
          ),
        );
    }
  }

  /// Gets the current model name string for display
  static String getModelName(LLMConfig config) {
    switch (config.provider) {
      case LLMProvider.local:
        return config.localModel;
      case LLMProvider.openai:
        return config.openaiModel;
      case LLMProvider.claude:
        return config.claudeModel;
    }
  }

  /// Checks if API key is required and available for the current provider
  static bool hasRequiredApiKey(LLMConfig config) {
    if (config.provider == LLMProvider.local) {
      return true; // Local doesn't need API key
    }
    return config.apiKey != null && config.apiKey!.isNotEmpty;
  }
}

/// Exception thrown when LLM configuration is invalid
class LLMConfigException implements Exception {
  final String message;
  LLMConfigException(this.message);

  @override
  String toString() => 'LLMConfigException: $message';
}
