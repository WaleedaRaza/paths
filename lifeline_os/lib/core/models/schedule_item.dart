import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_item.freezed.dart';
part 'schedule_item.g.dart';

@freezed
class ScheduleItem with _$ScheduleItem {
  const factory ScheduleItem({
    required String id,
    required DateTime date,
    String? taskId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    required DateTime createdAt,
  }) = _ScheduleItem;

  factory ScheduleItem.fromJson(Map<String, dynamic> json) =>
      _$ScheduleItemFromJson(json);
}

