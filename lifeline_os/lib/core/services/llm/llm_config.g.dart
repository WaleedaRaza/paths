// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LLMConfigImpl _$$LLMConfigImplFromJson(Map<String, dynamic> json) =>
    _$LLMConfigImpl(
      provider: $enumDecodeNullable(_$LLMProviderEnumMap, json['provider']) ??
          LLMProvider.local,
      apiKey: json['apiKey'] as String?,
      localModel: json['localModel'] as String? ?? 'llama3.1:8b',
      openaiModel: json['openaiModel'] as String? ?? 'gpt-4',
      claudeModel:
          json['claudeModel'] as String? ?? 'claude-3-5-sonnet-20241022',
    );

Map<String, dynamic> _$$LLMConfigImplToJson(_$LLMConfigImpl instance) =>
    <String, dynamic>{
      'provider': _$LLMProviderEnumMap[instance.provider]!,
      'apiKey': instance.apiKey,
      'localModel': instance.localModel,
      'openaiModel': instance.openaiModel,
      'claudeModel': instance.claudeModel,
    };

const _$LLMProviderEnumMap = {
  LLMProvider.local: 'local',
  LLMProvider.openai: 'openai',
  LLMProvider.claude: 'claude',
};
