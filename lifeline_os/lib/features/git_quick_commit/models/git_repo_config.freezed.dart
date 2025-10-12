// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'git_repo_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GitRepoConfig _$GitRepoConfigFromJson(Map<String, dynamic> json) {
  return _GitRepoConfig.fromJson(json);
}

/// @nodoc
mixin _$GitRepoConfig {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get githubUrl => throw _privateConstructorUsedError;
  String get localPath => throw _privateConstructorUsedError;
  DateTime? get lastCommitAt => throw _privateConstructorUsedError;
  String get authMethod => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  bool get isLinked => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GitRepoConfigCopyWith<GitRepoConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GitRepoConfigCopyWith<$Res> {
  factory $GitRepoConfigCopyWith(
          GitRepoConfig value, $Res Function(GitRepoConfig) then) =
      _$GitRepoConfigCopyWithImpl<$Res, GitRepoConfig>;
  @useResult
  $Res call(
      {String id,
      String name,
      String githubUrl,
      String localPath,
      DateTime? lastCommitAt,
      String authMethod,
      String? token,
      bool isLinked,
      DateTime createdAt});
}

/// @nodoc
class _$GitRepoConfigCopyWithImpl<$Res, $Val extends GitRepoConfig>
    implements $GitRepoConfigCopyWith<$Res> {
  _$GitRepoConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? githubUrl = null,
    Object? localPath = null,
    Object? lastCommitAt = freezed,
    Object? authMethod = null,
    Object? token = freezed,
    Object? isLinked = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      githubUrl: null == githubUrl
          ? _value.githubUrl
          : githubUrl // ignore: cast_nullable_to_non_nullable
              as String,
      localPath: null == localPath
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String,
      lastCommitAt: freezed == lastCommitAt
          ? _value.lastCommitAt
          : lastCommitAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      authMethod: null == authMethod
          ? _value.authMethod
          : authMethod // ignore: cast_nullable_to_non_nullable
              as String,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      isLinked: null == isLinked
          ? _value.isLinked
          : isLinked // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GitRepoConfigImplCopyWith<$Res>
    implements $GitRepoConfigCopyWith<$Res> {
  factory _$$GitRepoConfigImplCopyWith(
          _$GitRepoConfigImpl value, $Res Function(_$GitRepoConfigImpl) then) =
      __$$GitRepoConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String githubUrl,
      String localPath,
      DateTime? lastCommitAt,
      String authMethod,
      String? token,
      bool isLinked,
      DateTime createdAt});
}

/// @nodoc
class __$$GitRepoConfigImplCopyWithImpl<$Res>
    extends _$GitRepoConfigCopyWithImpl<$Res, _$GitRepoConfigImpl>
    implements _$$GitRepoConfigImplCopyWith<$Res> {
  __$$GitRepoConfigImplCopyWithImpl(
      _$GitRepoConfigImpl _value, $Res Function(_$GitRepoConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? githubUrl = null,
    Object? localPath = null,
    Object? lastCommitAt = freezed,
    Object? authMethod = null,
    Object? token = freezed,
    Object? isLinked = null,
    Object? createdAt = null,
  }) {
    return _then(_$GitRepoConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      githubUrl: null == githubUrl
          ? _value.githubUrl
          : githubUrl // ignore: cast_nullable_to_non_nullable
              as String,
      localPath: null == localPath
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String,
      lastCommitAt: freezed == lastCommitAt
          ? _value.lastCommitAt
          : lastCommitAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      authMethod: null == authMethod
          ? _value.authMethod
          : authMethod // ignore: cast_nullable_to_non_nullable
              as String,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      isLinked: null == isLinked
          ? _value.isLinked
          : isLinked // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GitRepoConfigImpl implements _GitRepoConfig {
  const _$GitRepoConfigImpl(
      {required this.id,
      required this.name,
      required this.githubUrl,
      required this.localPath,
      this.lastCommitAt,
      this.authMethod = 'ssh',
      this.token,
      this.isLinked = false,
      required this.createdAt});

  factory _$GitRepoConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$GitRepoConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String githubUrl;
  @override
  final String localPath;
  @override
  final DateTime? lastCommitAt;
  @override
  @JsonKey()
  final String authMethod;
  @override
  final String? token;
  @override
  @JsonKey()
  final bool isLinked;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'GitRepoConfig(id: $id, name: $name, githubUrl: $githubUrl, localPath: $localPath, lastCommitAt: $lastCommitAt, authMethod: $authMethod, token: $token, isLinked: $isLinked, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GitRepoConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.githubUrl, githubUrl) ||
                other.githubUrl == githubUrl) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath) &&
            (identical(other.lastCommitAt, lastCommitAt) ||
                other.lastCommitAt == lastCommitAt) &&
            (identical(other.authMethod, authMethod) ||
                other.authMethod == authMethod) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.isLinked, isLinked) ||
                other.isLinked == isLinked) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, githubUrl, localPath,
      lastCommitAt, authMethod, token, isLinked, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GitRepoConfigImplCopyWith<_$GitRepoConfigImpl> get copyWith =>
      __$$GitRepoConfigImplCopyWithImpl<_$GitRepoConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GitRepoConfigImplToJson(
      this,
    );
  }
}

abstract class _GitRepoConfig implements GitRepoConfig {
  const factory _GitRepoConfig(
      {required final String id,
      required final String name,
      required final String githubUrl,
      required final String localPath,
      final DateTime? lastCommitAt,
      final String authMethod,
      final String? token,
      final bool isLinked,
      required final DateTime createdAt}) = _$GitRepoConfigImpl;

  factory _GitRepoConfig.fromJson(Map<String, dynamic> json) =
      _$GitRepoConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get githubUrl;
  @override
  String get localPath;
  @override
  DateTime? get lastCommitAt;
  @override
  String get authMethod;
  @override
  String? get token;
  @override
  bool get isLinked;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$GitRepoConfigImplCopyWith<_$GitRepoConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
