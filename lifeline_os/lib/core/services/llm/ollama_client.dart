import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Client for interacting with local Ollama LLM service
class OllamaClient {
  final String baseUrl;
  final String model;
  final http.Client _httpClient;

  OllamaClient({
    this.baseUrl = 'http://localhost:11434',
    this.model = 'llama3.1:8b',
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  /// Generate streaming response from Ollama
  /// Returns stream of text tokens as they arrive
  Stream<String> generateStream({
    required String systemPrompt,
    required List<Map<String, String>> messages,
    double temperature = 0.7,
  }) async* {
    try {
      // Build messages with system prompt first
      final allMessages = <Map<String, String>>[
        {'role': 'system', 'content': systemPrompt},
        ...messages,
      ];
      
      // Build request body
      final requestBody = jsonEncode({
        'model': model,
        'messages': allMessages,
        'stream': true,
        'options': {
          'temperature': temperature,
          'num_predict': 2048,
        },
      });

      // Send POST request
      final uri = Uri.parse('$baseUrl/api/chat');
      final request = http.Request('POST', uri)
        ..headers['Content-Type'] = 'application/json'
        ..body = requestBody;

      final response = await _httpClient.send(request);

      if (response.statusCode != 200) {
        // Read error body
        final errorBody = await response.stream.bytesToString();
        throw OllamaException(
          'HTTP ${response.statusCode} - Model: $model - URL: $uri\nError: $errorBody',
        );
      }

      // Parse streaming response
      await for (final chunk in response.stream.transform(utf8.decoder)) {
        // Each line is a separate JSON object
        final lines = chunk.split('\n').where((line) => line.trim().isNotEmpty);
        
        for (final line in lines) {
          try {
            final data = jsonDecode(line);
            
            // Check for errors
            if (data['error'] != null) {
              throw OllamaException(data['error']);
            }
            
            // Extract token from message content
            final message = data['message'];
            if (message != null && message['content'] != null) {
              yield message['content'] as String;
            }
            
            // Check if done
            if (data['done'] == true) {
              break;
            }
          } catch (e) {
            // Skip malformed JSON lines
            continue;
          }
        }
      }
    } catch (e) {
      if (e is OllamaException) rethrow;
      throw OllamaException('Failed to connect to Ollama: $e');
    }
  }

  /// Check if Ollama service is available
  Future<bool> isAvailable() async {
    try {
      final response = await _httpClient.get(Uri.parse('$baseUrl/api/tags'))
        .timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Get list of available models
  Future<List<String>> getModels() async {
    try {
      final response = await _httpClient.get(Uri.parse('$baseUrl/api/tags'));
      
      if (response.statusCode != 200) {
        throw OllamaException('Failed to fetch models');
      }
      
      final data = jsonDecode(response.body);
      final models = data['models'] as List?;
      
      return models?.map((m) => m['name'] as String).toList() ?? [];
    } catch (e) {
      throw OllamaException('Failed to fetch models: $e');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}

/// Exception thrown when Ollama operations fail
class OllamaException implements Exception {
  final String message;
  
  OllamaException(this.message);
  
  @override
  String toString() => 'OllamaException: $message';
}

