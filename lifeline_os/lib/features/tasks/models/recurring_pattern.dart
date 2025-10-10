import 'dart:convert';

/// Represents a recurring task pattern
class RecurringPattern {
  final RecurringType type;
  final int? intervalDays; // For custom intervals
  final List<int>? weekdays; // 1=Monday, 7=Sunday
  final DateTime? endDate; // When to stop recurring
  
  const RecurringPattern({
    required this.type,
    this.intervalDays,
    this.weekdays,
    this.endDate,
  });
  
  factory RecurringPattern.fromJson(Map<String, dynamic> json) {
    return RecurringPattern(
      type: RecurringType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => RecurringType.none,
      ),
      intervalDays: json['intervalDays'] as int?,
      weekdays: (json['weekdays'] as List<dynamic>?)?.cast<int>(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      if (intervalDays != null) 'intervalDays': intervalDays,
      if (weekdays != null) 'weekdays': weekdays,
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
    };
  }
  
  String toJsonString() => jsonEncode(toJson());
  
  factory RecurringPattern.fromJsonString(String jsonStr) {
    return RecurringPattern.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
  }
  
  String get displayText {
    switch (type) {
      case RecurringType.none:
        return 'One-time';
      case RecurringType.daily:
        return 'Daily';
      case RecurringType.weekly:
        return 'Weekly';
      case RecurringType.weekdays:
        return 'Weekdays (Mon-Fri)';
      case RecurringType.custom:
        if (weekdays != null && weekdays!.isNotEmpty) {
          final days = weekdays!.map((d) => _dayName(d)).join(', ');
          return 'Custom: $days';
        }
        if (intervalDays != null) {
          return 'Every $intervalDays days';
        }
        return 'Custom';
    }
  }
  
  String _dayName(int day) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[(day - 1) % 7];
  }
  
  static RecurringPattern none() => const RecurringPattern(type: RecurringType.none);
  static RecurringPattern daily() => const RecurringPattern(type: RecurringType.daily);
  static RecurringPattern weekly() => const RecurringPattern(type: RecurringType.weekly);
  static RecurringPattern weekdays() => const RecurringPattern(type: RecurringType.weekdays, weekdays: [1, 2, 3, 4, 5]);
  static RecurringPattern customDays(List<int> weekdays) => RecurringPattern(type: RecurringType.custom, weekdays: weekdays);
}

enum RecurringType {
  none,      // One-time task
  daily,     // Every day
  weekly,    // Every 7 days
  weekdays,  // Monday through Friday
  custom,    // Custom days or interval
}

