// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'llm_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LLMConfig _$LLMConfigFromJson(Map<String, dynamic> json) {
  return _LLMConfig.fromJson(json);
}

/// @nodoc
mixin _$LLMConfig {
  LLMProvider get provider => throw _privateConstructorUsedError;
  String? get apiKey => throw _privateConstructorUsedError;
  String get localModel => throw _privateConstructorUsedError;
  String get openaiModel => throw _privateConstructorUsedError;
  String get claudeModel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LLMConfigCopyWith<LLMConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LLMConfigCopyWith<$Res> {
  factory $LLMConfigCopyWith(LLMConfig value, $Res Function(LLMConfig) then) =
      _$LLMConfigCopyWithImpl<$Res, LLMConfig>;
  @useResult
  $Res call(
      {LLMProvider provider,
      String? apiKey,
      String localModel,
      String openaiModel,
      String claudeModel});
}

/// @nodoc
class _$LLMConfigCopyWithImpl<$Res, $Val extends LLMConfig>
    implements $LLMConfigCopyWith<$Res> {
  _$LLMConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? apiKey = freezed,
    Object? localModel = null,
    Object? openaiModel = null,
    Object? claudeModel = null,
  }) {
    return _then(_value.copyWith(
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as LLMProvider,
      apiKey: freezed == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      localModel: null == localModel
          ? _value.localModel
          : localModel // ignore: cast_nullable_to_non_nullable
              as String,
      openaiModel: null == openaiModel
          ? _value.openaiModel
          : openaiModel // ignore: cast_nullable_to_non_nullable
              as String,
      claudeModel: null == claudeModel
          ? _value.claudeModel
          : claudeModel // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LLMConfigImplCopyWith<$Res>
    implements $LLMConfigCopyWith<$Res> {
  factory _$$LLMConfigImplCopyWith(
          _$LLMConfigImpl value, $Res Function(_$LLMConfigImpl) then) =
      __$$LLMConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LLMProvider provider,
      String? apiKey,
      String localModel,
      String openaiModel,
      String claudeModel});
}

/// @nodoc
class __$$LLMConfigImplCopyWithImpl<$Res>
    extends _$LLMConfigCopyWithImpl<$Res, _$LLMConfigImpl>
    implements _$$LLMConfigImplCopyWith<$Res> {
  __$$LLMConfigImplCopyWithImpl(
      _$LLMConfigImpl _value, $Res Function(_$LLMConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? apiKey = freezed,
    Object? localModel = null,
    Object? openaiModel = null,
    Object? claudeModel = null,
  }) {
    return _then(_$LLMConfigImpl(
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as LLMProvider,
      apiKey: freezed == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      localModel: null == localModel
          ? _value.localModel
          : localModel // ignore: cast_nullable_to_non_nullable
              as String,
      openaiModel: null == openaiModel
          ? _value.openaiModel
          : openaiModel // ignore: cast_nullable_to_non_nullable
              as String,
      claudeModel: null == claudeModel
          ? _value.claudeModel
          : claudeModel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LLMConfigImpl implements _LLMConfig {
  const _$LLMConfigImpl(
      {this.provider = LLMProvider.local,
      this.apiKey,
      this.localModel = 'llama3.1:8b',
      this.openaiModel = 'gpt-4',
      this.claudeModel = 'claude-3-5-sonnet-20241022'});

  factory _$LLMConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$LLMConfigImplFromJson(json);

  @override
  @JsonKey()
  final LLMProvider provider;
  @override
  final String? apiKey;
  @override
  @JsonKey()
  final String localModel;
  @override
  @JsonKey()
  final String openaiModel;
  @override
  @JsonKey()
  final String claudeModel;

  @override
  String toString() {
    return 'LLMConfig(provider: $provider, apiKey: $apiKey, localModel: $localModel, openaiModel: $openaiModel, claudeModel: $claudeModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LLMConfigImpl &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.localModel, localModel) ||
                other.localModel == localModel) &&
            (identical(other.openaiModel, openaiModel) ||
                other.openaiModel == openaiModel) &&
            (identical(other.claudeModel, claudeModel) ||
                other.claudeModel == claudeModel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, provider, apiKey, localModel, openaiModel, claudeModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LLMConfigImplCopyWith<_$LLMConfigImpl> get copyWith =>
      __$$LLMConfigImplCopyWithImpl<_$LLMConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LLMConfigImplToJson(
      this,
    );
  }
}

abstract class _LLMConfig implements LLMConfig {
  const factory _LLMConfig(
      {final LLMProvider provider,
      final String? apiKey,
      final String localModel,
      final String openaiModel,
      final String claudeModel}) = _$LLMConfigImpl;

  factory _LLMConfig.fromJson(Map<String, dynamic> json) =
      _$LLMConfigImpl.fromJson;

  @override
  LLMProvider get provider;
  @override
  String? get apiKey;
  @override
  String get localModel;
  @override
  String get openaiModel;
  @override
  String get claudeModel;
  @override
  @JsonKey(ignore: true)
  _$$LLMConfigImplCopyWith<_$LLMConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
