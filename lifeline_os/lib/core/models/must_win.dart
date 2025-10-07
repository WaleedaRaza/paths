import 'package:freezed_annotation/freezed_annotation.dart';

part 'must_win.freezed.dart';
part 'must_win.g.dart';

@freezed
class MustWin with _$MustWin {
  const factory MustWin({
    required String id,
    required DateTime date,
    String? taskId,
    required String title,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    @Default(0) int sortOrder,
    required DateTime createdAt,
  }) = _MustWin;

  factory MustWin.fromJson(Map<String, dynamic> json) =>
      _$MustWinFromJson(json);
}

