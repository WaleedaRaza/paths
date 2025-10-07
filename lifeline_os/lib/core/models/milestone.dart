import 'package:freezed_annotation/freezed_annotation.dart';
import '../database/tables.dart';

part 'milestone.freezed.dart';
part 'milestone.g.dart';

@freezed
class Milestone with _$Milestone {
  const factory Milestone({
    required String id,
    required String title,
    String? description,
    String? categoryId,
    @Default(Domain.personal) Domain domain,
    String? metadata, // JSON string for domain-specific data
    DateTime? deadline,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    @Default(0) int totalPoints,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Milestone;

  factory Milestone.fromJson(Map<String, dynamic> json) =>
      _$MilestoneFromJson(json);
}

