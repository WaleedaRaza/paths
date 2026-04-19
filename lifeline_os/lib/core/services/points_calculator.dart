import '../database/tables.dart';

/// Smart points calculator that considers:
/// - Time investment (estimatedMinutes)
/// - Priority level
/// - Domain-specific value
/// 
/// Base formula: 1 hour of focused work = 100 points
class PointsCalculator {
  /// Calculate points for a task
  /// 
  /// Returns a map with:
  /// - effortPoints: Time-based points (1 hr = 100pts)
  /// - impactPoints: Domain-specific value points
  /// - totalPoints: Final calculated points
  static Map<String, int> calculateTaskPoints({
    required Domain domain,
    int? estimatedMinutes,
    required int priority, // 0=none, 1=low, 2=medium, 3=high
    int energy = 0, // 0=none, 1=low, 2=medium, 3=high
    Map<String, dynamic>? metadata,
  }) {
    // Calculate Effort Points (time-based)
    int effortPoints = _calculateEffortPoints(estimatedMinutes, energy);
    
    // Calculate Impact Points (domain-specific)
    int impactPoints = _calculateImpactPoints(domain, metadata);
    
    // Priority multiplier
    double priorityMultiplier = _getPriorityMultiplier(priority);
    
    // Combined total (weighted average)
    // Effort = 40%, Impact = 50%, Priority boost = 10%
    int totalPoints = (
      (effortPoints * 0.4) +
      (impactPoints * 0.5) +
      (effortPoints * priorityMultiplier * 0.1)
    ).round();
    
    // Minimum points = 10
    totalPoints = totalPoints < 10 ? 10 : totalPoints;
    
    return {
      'effortPoints': effortPoints,
      'impactPoints': impactPoints,
      'totalPoints': totalPoints,
    };
  }
  
  /// Calculate effort points based on time and energy
  static int _calculateEffortPoints(int? estimatedMinutes, int energy) {
    if (estimatedMinutes == null || estimatedMinutes <= 0) {
      // Default: 1 hour = 100 points
      return 100;
    }
    
    // Base: 1 hour = 100 points
    int basePoints = (estimatedMinutes / 60 * 100).round();
    
    // Energy multiplier (high energy tasks = more effort)
    double energyMultiplier = switch (energy) {
      3 => 1.3, // High energy
      2 => 1.1, // Medium energy
      1 => 0.9, // Low energy
      _ => 1.0, // None/default
    };
    
    return (basePoints * energyMultiplier).round();
  }
  
  /// Calculate impact points based on domain-specific value
  static int _calculateImpactPoints(Domain domain, Map<String, dynamic>? metadata) {
    switch (domain) {
      case Domain.finance:
        return _financeImpact(metadata);
      case Domain.school:
        return _schoolImpact(metadata);
      case Domain.projects:
        return _projectsImpact(metadata);
      case Domain.career:
        return _careerImpact(metadata);
      case Domain.health:
        return _healthImpact(metadata);
      case Domain.dsa:
        return _dsaImpact(metadata);
      case Domain.gre:
        return _greImpact(metadata);
      case Domain.personal:
        return _personalImpact(metadata);
    }
  }
  
  /// Get priority multiplier
  static double _getPriorityMultiplier(int priority) {
    return switch (priority) {
      3 => 1.5, // High priority
      2 => 1.2, // Medium priority
      1 => 1.0, // Low priority
      _ => 1.0, // None
    };
  }
  
  // Domain-specific impact calculations
  
  /// Finance: $1 = 1 impact point, milestone bonuses
  static int _financeImpact(Map<String, dynamic>? metadata) {
    if (metadata == null) return 100;
    
    // Dollar value mapping
    final dollarValue = metadata['dollarValue'] as int?;
    if (dollarValue != null) return dollarValue;
    
    // Milestone achievements
    final milestone = metadata['milestone'] as String?;
    return switch (milestone) {
      'milestone_10k' => 25000,
      'milestone_5k' => 10000,
      'milestone_1k' => 2000,
      'trade_win' => 500,
      _ => 100,
    };
  }
  
  /// School: Course completion = 5000, assignments = 300
  static int _schoolImpact(Map<String, dynamic>? metadata) {
    if (metadata == null) return 100;
    
    final type = metadata['type'] as String?;
    return switch (type) {
      'course_complete' => 5000,
      'exam' => 800,
      'project' => 500,
      'assignment' => 300,
      'notes' => 150,
      'reading' => 100,
      'practice' => 100,
      _ => 100,
    };
  }
  
  /// Projects: Shipping = 50000, features = 2000
  static int _projectsImpact(Map<String, dynamic>? metadata) {
    if (metadata == null) return 500;
    
    final milestone = metadata['milestone'] as String?;
    final isShipping = metadata['isShipping'] as bool? ?? false;
    
    if (isShipping) return 50000;
    
    return switch (milestone) {
      'ship_v1' => 50000,
      'feature' => 2000,
      'pr_merged' => 300,
      'bug_fix' => 100,
      _ => 500,
    };
  }
  
  /// Career: Job offer = 100k, interviews = 500
  static int _careerImpact(Map<String, dynamic>? metadata) {
    if (metadata == null) return 200;
    
    final type = metadata['type'] as String?;
    return switch (type) {
      'offer_received' => 100000,
      'interview_done' => 500,
      'resume_update' => 300,
      'coffee_chat' => 200,
      'application_sent' => 100,
      _ => 200,
    };
  }
  
  /// Health: Workout = 200, weekly adherence = 1000
  static int _healthImpact(Map<String, dynamic>? metadata) {
    if (metadata == null) return 200;
    
    final type = metadata['type'] as String?;
    return switch (type) {
      'cycle_complete' => 8000,
      'week_adherence' => 1000,
      'workout_done' => 200,
      _ => 200,
    };
  }
  
  /// DSA/LeetCode: Hard = 400, Medium = 150, Easy = 50
  static int _dsaImpact(Map<String, dynamic>? metadata) {
    if (metadata == null) return 150;
    
    final difficulty = metadata['difficulty'] as String?;
    final type = metadata['type'] as String?;
    
    if (type == 'pattern_mastered') return 1000;
    
    return switch (difficulty) {
      'hard' => 400,
      'medium' => 150,
      'easy' => 50,
      _ => 150,
    };
  }
  
  /// GRE: Full mock = 500, practice set = 100
  static int _greImpact(Map<String, dynamic>? metadata) {
    if (metadata == null) return 100;
    
    final type = metadata['type'] as String?;
    return switch (type) {
      'full_mock_test' => 500,
      'essay_written' => 200,
      'practice_set' => 100,
      'vocab_session' => 50,
      _ => 100,
    };
  }
  
  /// Personal: General tasks
  static int _personalImpact(Map<String, dynamic>? metadata) {
    return 100; // Base value for personal tasks
  }
}

