// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'music_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MusicStats _$MusicStatsFromJson(Map<String, dynamic> json) {
  return _MusicStats.fromJson(json);
}

/// @nodoc
mixin _$MusicStats {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get period =>
      throw _privateConstructorUsedError; // 'day', 'week', 'month', 'year'
  Map<String, int> get topArtists => throw _privateConstructorUsedError;
  Map<String, int> get topTracks => throw _privateConstructorUsedError;
  Map<String, int> get topGenres => throw _privateConstructorUsedError;
  int get totalMinutes => throw _privateConstructorUsedError;
  int get uniqueArtists => throw _privateConstructorUsedError;
  int get uniqueTracks => throw _privateConstructorUsedError;
  int get newArtistsDiscovered => throw _privateConstructorUsedError;
  Map<int, int> get hourlyMinutes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MusicStatsCopyWith<MusicStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MusicStatsCopyWith<$Res> {
  factory $MusicStatsCopyWith(
          MusicStats value, $Res Function(MusicStats) then) =
      _$MusicStatsCopyWithImpl<$Res, MusicStats>;
  @useResult
  $Res call(
      {String id,
      DateTime date,
      String period,
      Map<String, int> topArtists,
      Map<String, int> topTracks,
      Map<String, int> topGenres,
      int totalMinutes,
      int uniqueArtists,
      int uniqueTracks,
      int newArtistsDiscovered,
      Map<int, int> hourlyMinutes,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$MusicStatsCopyWithImpl<$Res, $Val extends MusicStats>
    implements $MusicStatsCopyWith<$Res> {
  _$MusicStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? period = null,
    Object? topArtists = null,
    Object? topTracks = null,
    Object? topGenres = null,
    Object? totalMinutes = null,
    Object? uniqueArtists = null,
    Object? uniqueTracks = null,
    Object? newArtistsDiscovered = null,
    Object? hourlyMinutes = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      topArtists: null == topArtists
          ? _value.topArtists
          : topArtists // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      topTracks: null == topTracks
          ? _value.topTracks
          : topTracks // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      topGenres: null == topGenres
          ? _value.topGenres
          : topGenres // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      totalMinutes: null == totalMinutes
          ? _value.totalMinutes
          : totalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueArtists: null == uniqueArtists
          ? _value.uniqueArtists
          : uniqueArtists // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueTracks: null == uniqueTracks
          ? _value.uniqueTracks
          : uniqueTracks // ignore: cast_nullable_to_non_nullable
              as int,
      newArtistsDiscovered: null == newArtistsDiscovered
          ? _value.newArtistsDiscovered
          : newArtistsDiscovered // ignore: cast_nullable_to_non_nullable
              as int,
      hourlyMinutes: null == hourlyMinutes
          ? _value.hourlyMinutes
          : hourlyMinutes // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MusicStatsImplCopyWith<$Res>
    implements $MusicStatsCopyWith<$Res> {
  factory _$$MusicStatsImplCopyWith(
          _$MusicStatsImpl value, $Res Function(_$MusicStatsImpl) then) =
      __$$MusicStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime date,
      String period,
      Map<String, int> topArtists,
      Map<String, int> topTracks,
      Map<String, int> topGenres,
      int totalMinutes,
      int uniqueArtists,
      int uniqueTracks,
      int newArtistsDiscovered,
      Map<int, int> hourlyMinutes,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$MusicStatsImplCopyWithImpl<$Res>
    extends _$MusicStatsCopyWithImpl<$Res, _$MusicStatsImpl>
    implements _$$MusicStatsImplCopyWith<$Res> {
  __$$MusicStatsImplCopyWithImpl(
      _$MusicStatsImpl _value, $Res Function(_$MusicStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? period = null,
    Object? topArtists = null,
    Object? topTracks = null,
    Object? topGenres = null,
    Object? totalMinutes = null,
    Object? uniqueArtists = null,
    Object? uniqueTracks = null,
    Object? newArtistsDiscovered = null,
    Object? hourlyMinutes = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$MusicStatsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      topArtists: null == topArtists
          ? _value._topArtists
          : topArtists // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      topTracks: null == topTracks
          ? _value._topTracks
          : topTracks // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      topGenres: null == topGenres
          ? _value._topGenres
          : topGenres // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      totalMinutes: null == totalMinutes
          ? _value.totalMinutes
          : totalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueArtists: null == uniqueArtists
          ? _value.uniqueArtists
          : uniqueArtists // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueTracks: null == uniqueTracks
          ? _value.uniqueTracks
          : uniqueTracks // ignore: cast_nullable_to_non_nullable
              as int,
      newArtistsDiscovered: null == newArtistsDiscovered
          ? _value.newArtistsDiscovered
          : newArtistsDiscovered // ignore: cast_nullable_to_non_nullable
              as int,
      hourlyMinutes: null == hourlyMinutes
          ? _value._hourlyMinutes
          : hourlyMinutes // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MusicStatsImpl implements _MusicStats {
  const _$MusicStatsImpl(
      {required this.id,
      required this.date,
      required this.period,
      required final Map<String, int> topArtists,
      required final Map<String, int> topTracks,
      required final Map<String, int> topGenres,
      required this.totalMinutes,
      required this.uniqueArtists,
      required this.uniqueTracks,
      required this.newArtistsDiscovered,
      required final Map<int, int> hourlyMinutes,
      required this.createdAt,
      required this.updatedAt})
      : _topArtists = topArtists,
        _topTracks = topTracks,
        _topGenres = topGenres,
        _hourlyMinutes = hourlyMinutes;

  factory _$MusicStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MusicStatsImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  final String period;
// 'day', 'week', 'month', 'year'
  final Map<String, int> _topArtists;
// 'day', 'week', 'month', 'year'
  @override
  Map<String, int> get topArtists {
    if (_topArtists is EqualUnmodifiableMapView) return _topArtists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_topArtists);
  }

  final Map<String, int> _topTracks;
  @override
  Map<String, int> get topTracks {
    if (_topTracks is EqualUnmodifiableMapView) return _topTracks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_topTracks);
  }

  final Map<String, int> _topGenres;
  @override
  Map<String, int> get topGenres {
    if (_topGenres is EqualUnmodifiableMapView) return _topGenres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_topGenres);
  }

  @override
  final int totalMinutes;
  @override
  final int uniqueArtists;
  @override
  final int uniqueTracks;
  @override
  final int newArtistsDiscovered;
  final Map<int, int> _hourlyMinutes;
  @override
  Map<int, int> get hourlyMinutes {
    if (_hourlyMinutes is EqualUnmodifiableMapView) return _hourlyMinutes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_hourlyMinutes);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MusicStats(id: $id, date: $date, period: $period, topArtists: $topArtists, topTracks: $topTracks, topGenres: $topGenres, totalMinutes: $totalMinutes, uniqueArtists: $uniqueArtists, uniqueTracks: $uniqueTracks, newArtistsDiscovered: $newArtistsDiscovered, hourlyMinutes: $hourlyMinutes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MusicStatsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.period, period) || other.period == period) &&
            const DeepCollectionEquality()
                .equals(other._topArtists, _topArtists) &&
            const DeepCollectionEquality()
                .equals(other._topTracks, _topTracks) &&
            const DeepCollectionEquality()
                .equals(other._topGenres, _topGenres) &&
            (identical(other.totalMinutes, totalMinutes) ||
                other.totalMinutes == totalMinutes) &&
            (identical(other.uniqueArtists, uniqueArtists) ||
                other.uniqueArtists == uniqueArtists) &&
            (identical(other.uniqueTracks, uniqueTracks) ||
                other.uniqueTracks == uniqueTracks) &&
            (identical(other.newArtistsDiscovered, newArtistsDiscovered) ||
                other.newArtistsDiscovered == newArtistsDiscovered) &&
            const DeepCollectionEquality()
                .equals(other._hourlyMinutes, _hourlyMinutes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      date,
      period,
      const DeepCollectionEquality().hash(_topArtists),
      const DeepCollectionEquality().hash(_topTracks),
      const DeepCollectionEquality().hash(_topGenres),
      totalMinutes,
      uniqueArtists,
      uniqueTracks,
      newArtistsDiscovered,
      const DeepCollectionEquality().hash(_hourlyMinutes),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MusicStatsImplCopyWith<_$MusicStatsImpl> get copyWith =>
      __$$MusicStatsImplCopyWithImpl<_$MusicStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MusicStatsImplToJson(
      this,
    );
  }
}

abstract class _MusicStats implements MusicStats {
  const factory _MusicStats(
      {required final String id,
      required final DateTime date,
      required final String period,
      required final Map<String, int> topArtists,
      required final Map<String, int> topTracks,
      required final Map<String, int> topGenres,
      required final int totalMinutes,
      required final int uniqueArtists,
      required final int uniqueTracks,
      required final int newArtistsDiscovered,
      required final Map<int, int> hourlyMinutes,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$MusicStatsImpl;

  factory _MusicStats.fromJson(Map<String, dynamic> json) =
      _$MusicStatsImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  String get period;
  @override // 'day', 'week', 'month', 'year'
  Map<String, int> get topArtists;
  @override
  Map<String, int> get topTracks;
  @override
  Map<String, int> get topGenres;
  @override
  int get totalMinutes;
  @override
  int get uniqueArtists;
  @override
  int get uniqueTracks;
  @override
  int get newArtistsDiscovered;
  @override
  Map<int, int> get hourlyMinutes;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$MusicStatsImplCopyWith<_$MusicStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopItem _$TopItemFromJson(Map<String, dynamic> json) {
  return _TopItem.fromJson(json);
}

/// @nodoc
mixin _$TopItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get playCount => throw _privateConstructorUsedError;
  int get totalMinutes => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TopItemCopyWith<TopItem> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopItemCopyWith<$Res> {
  factory $TopItemCopyWith(TopItem value, $Res Function(TopItem) then) =
      _$TopItemCopyWithImpl<$Res, TopItem>;
  @useResult
  $Res call(
      {String id,
      String name,
      int playCount,
      int totalMinutes,
      String? imageUrl,
      String? subtitle});
}

/// @nodoc
class _$TopItemCopyWithImpl<$Res, $Val extends TopItem>
    implements $TopItemCopyWith<$Res> {
  _$TopItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? playCount = null,
    Object? totalMinutes = null,
    Object? imageUrl = freezed,
    Object? subtitle = freezed,
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
      playCount: null == playCount
          ? _value.playCount
          : playCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalMinutes: null == totalMinutes
          ? _value.totalMinutes
          : totalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopItemImplCopyWith<$Res> implements $TopItemCopyWith<$Res> {
  factory _$$TopItemImplCopyWith(
          _$TopItemImpl value, $Res Function(_$TopItemImpl) then) =
      __$$TopItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int playCount,
      int totalMinutes,
      String? imageUrl,
      String? subtitle});
}

/// @nodoc
class __$$TopItemImplCopyWithImpl<$Res>
    extends _$TopItemCopyWithImpl<$Res, _$TopItemImpl>
    implements _$$TopItemImplCopyWith<$Res> {
  __$$TopItemImplCopyWithImpl(
      _$TopItemImpl _value, $Res Function(_$TopItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? playCount = null,
    Object? totalMinutes = null,
    Object? imageUrl = freezed,
    Object? subtitle = freezed,
  }) {
    return _then(_$TopItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      playCount: null == playCount
          ? _value.playCount
          : playCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalMinutes: null == totalMinutes
          ? _value.totalMinutes
          : totalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopItemImpl implements _TopItem {
  const _$TopItemImpl(
      {required this.id,
      required this.name,
      required this.playCount,
      required this.totalMinutes,
      this.imageUrl,
      this.subtitle});

  factory _$TopItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int playCount;
  @override
  final int totalMinutes;
  @override
  final String? imageUrl;
  @override
  final String? subtitle;

  @override
  String toString() {
    return 'TopItem(id: $id, name: $name, playCount: $playCount, totalMinutes: $totalMinutes, imageUrl: $imageUrl, subtitle: $subtitle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.playCount, playCount) ||
                other.playCount == playCount) &&
            (identical(other.totalMinutes, totalMinutes) ||
                other.totalMinutes == totalMinutes) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, playCount, totalMinutes, imageUrl, subtitle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TopItemImplCopyWith<_$TopItemImpl> get copyWith =>
      __$$TopItemImplCopyWithImpl<_$TopItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopItemImplToJson(
      this,
    );
  }
}

abstract class _TopItem implements TopItem {
  const factory _TopItem(
      {required final String id,
      required final String name,
      required final int playCount,
      required final int totalMinutes,
      final String? imageUrl,
      final String? subtitle}) = _$TopItemImpl;

  factory _TopItem.fromJson(Map<String, dynamic> json) = _$TopItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get playCount;
  @override
  int get totalMinutes;
  @override
  String? get imageUrl;
  @override
  String? get subtitle;
  @override
  @JsonKey(ignore: true)
  _$$TopItemImplCopyWith<_$TopItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ListeningPattern _$ListeningPatternFromJson(Map<String, dynamic> json) {
  return _ListeningPattern.fromJson(json);
}

/// @nodoc
mixin _$ListeningPattern {
  Map<int, int> get hourlyMinutes =>
      throw _privateConstructorUsedError; // hour -> minutes
  Map<String, int> get dayOfWeekMinutes =>
      throw _privateConstructorUsedError; // day -> minutes
  int get peakHour => throw _privateConstructorUsedError;
  String get peakDay => throw _privateConstructorUsedError;
  double get avgDailyMinutes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListeningPatternCopyWith<ListeningPattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListeningPatternCopyWith<$Res> {
  factory $ListeningPatternCopyWith(
          ListeningPattern value, $Res Function(ListeningPattern) then) =
      _$ListeningPatternCopyWithImpl<$Res, ListeningPattern>;
  @useResult
  $Res call(
      {Map<int, int> hourlyMinutes,
      Map<String, int> dayOfWeekMinutes,
      int peakHour,
      String peakDay,
      double avgDailyMinutes});
}

/// @nodoc
class _$ListeningPatternCopyWithImpl<$Res, $Val extends ListeningPattern>
    implements $ListeningPatternCopyWith<$Res> {
  _$ListeningPatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hourlyMinutes = null,
    Object? dayOfWeekMinutes = null,
    Object? peakHour = null,
    Object? peakDay = null,
    Object? avgDailyMinutes = null,
  }) {
    return _then(_value.copyWith(
      hourlyMinutes: null == hourlyMinutes
          ? _value.hourlyMinutes
          : hourlyMinutes // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      dayOfWeekMinutes: null == dayOfWeekMinutes
          ? _value.dayOfWeekMinutes
          : dayOfWeekMinutes // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      peakHour: null == peakHour
          ? _value.peakHour
          : peakHour // ignore: cast_nullable_to_non_nullable
              as int,
      peakDay: null == peakDay
          ? _value.peakDay
          : peakDay // ignore: cast_nullable_to_non_nullable
              as String,
      avgDailyMinutes: null == avgDailyMinutes
          ? _value.avgDailyMinutes
          : avgDailyMinutes // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListeningPatternImplCopyWith<$Res>
    implements $ListeningPatternCopyWith<$Res> {
  factory _$$ListeningPatternImplCopyWith(_$ListeningPatternImpl value,
          $Res Function(_$ListeningPatternImpl) then) =
      __$$ListeningPatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<int, int> hourlyMinutes,
      Map<String, int> dayOfWeekMinutes,
      int peakHour,
      String peakDay,
      double avgDailyMinutes});
}

/// @nodoc
class __$$ListeningPatternImplCopyWithImpl<$Res>
    extends _$ListeningPatternCopyWithImpl<$Res, _$ListeningPatternImpl>
    implements _$$ListeningPatternImplCopyWith<$Res> {
  __$$ListeningPatternImplCopyWithImpl(_$ListeningPatternImpl _value,
      $Res Function(_$ListeningPatternImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hourlyMinutes = null,
    Object? dayOfWeekMinutes = null,
    Object? peakHour = null,
    Object? peakDay = null,
    Object? avgDailyMinutes = null,
  }) {
    return _then(_$ListeningPatternImpl(
      hourlyMinutes: null == hourlyMinutes
          ? _value._hourlyMinutes
          : hourlyMinutes // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      dayOfWeekMinutes: null == dayOfWeekMinutes
          ? _value._dayOfWeekMinutes
          : dayOfWeekMinutes // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      peakHour: null == peakHour
          ? _value.peakHour
          : peakHour // ignore: cast_nullable_to_non_nullable
              as int,
      peakDay: null == peakDay
          ? _value.peakDay
          : peakDay // ignore: cast_nullable_to_non_nullable
              as String,
      avgDailyMinutes: null == avgDailyMinutes
          ? _value.avgDailyMinutes
          : avgDailyMinutes // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListeningPatternImpl implements _ListeningPattern {
  const _$ListeningPatternImpl(
      {required final Map<int, int> hourlyMinutes,
      required final Map<String, int> dayOfWeekMinutes,
      required this.peakHour,
      required this.peakDay,
      required this.avgDailyMinutes})
      : _hourlyMinutes = hourlyMinutes,
        _dayOfWeekMinutes = dayOfWeekMinutes;

  factory _$ListeningPatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListeningPatternImplFromJson(json);

  final Map<int, int> _hourlyMinutes;
  @override
  Map<int, int> get hourlyMinutes {
    if (_hourlyMinutes is EqualUnmodifiableMapView) return _hourlyMinutes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_hourlyMinutes);
  }

// hour -> minutes
  final Map<String, int> _dayOfWeekMinutes;
// hour -> minutes
  @override
  Map<String, int> get dayOfWeekMinutes {
    if (_dayOfWeekMinutes is EqualUnmodifiableMapView) return _dayOfWeekMinutes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dayOfWeekMinutes);
  }

// day -> minutes
  @override
  final int peakHour;
  @override
  final String peakDay;
  @override
  final double avgDailyMinutes;

  @override
  String toString() {
    return 'ListeningPattern(hourlyMinutes: $hourlyMinutes, dayOfWeekMinutes: $dayOfWeekMinutes, peakHour: $peakHour, peakDay: $peakDay, avgDailyMinutes: $avgDailyMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListeningPatternImpl &&
            const DeepCollectionEquality()
                .equals(other._hourlyMinutes, _hourlyMinutes) &&
            const DeepCollectionEquality()
                .equals(other._dayOfWeekMinutes, _dayOfWeekMinutes) &&
            (identical(other.peakHour, peakHour) ||
                other.peakHour == peakHour) &&
            (identical(other.peakDay, peakDay) || other.peakDay == peakDay) &&
            (identical(other.avgDailyMinutes, avgDailyMinutes) ||
                other.avgDailyMinutes == avgDailyMinutes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_hourlyMinutes),
      const DeepCollectionEquality().hash(_dayOfWeekMinutes),
      peakHour,
      peakDay,
      avgDailyMinutes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListeningPatternImplCopyWith<_$ListeningPatternImpl> get copyWith =>
      __$$ListeningPatternImplCopyWithImpl<_$ListeningPatternImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListeningPatternImplToJson(
      this,
    );
  }
}

abstract class _ListeningPattern implements ListeningPattern {
  const factory _ListeningPattern(
      {required final Map<int, int> hourlyMinutes,
      required final Map<String, int> dayOfWeekMinutes,
      required final int peakHour,
      required final String peakDay,
      required final double avgDailyMinutes}) = _$ListeningPatternImpl;

  factory _ListeningPattern.fromJson(Map<String, dynamic> json) =
      _$ListeningPatternImpl.fromJson;

  @override
  Map<int, int> get hourlyMinutes;
  @override // hour -> minutes
  Map<String, int> get dayOfWeekMinutes;
  @override // day -> minutes
  int get peakHour;
  @override
  String get peakDay;
  @override
  double get avgDailyMinutes;
  @override
  @JsonKey(ignore: true)
  _$$ListeningPatternImplCopyWith<_$ListeningPatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
