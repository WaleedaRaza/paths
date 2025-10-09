/// Parses user intent to extract hard constraints for LLM generation
class IntentParser {
  final String action;
  final int? minCount;
  final int? maxCount;
  final int targetCount;
  final String verb;
  final String cleanedIntent;

  IntentParser({
    required this.action,
    this.minCount,
    this.maxCount,
    required this.targetCount,
    required this.verb,
    required this.cleanedIntent,
  });

  factory IntentParser.parse(String userIntent, String action) {
    // Extract number patterns: "10-20", "30", "at least 15", etc.
    final rangePattern = RegExp(r'(\d+)\s*[-–—to]\s*(\d+)');
    final singlePattern = RegExp(r'(\d+)\s+(?:items?|features?|points?|lines?|examples?)');
    final atLeastPattern = RegExp(r'at least (\d+)');
    final exactlyPattern = RegExp(r'exactly (\d+)');
    
    int? min;
    int? max;
    int target;
    String verb = action;
    
    // Try range first: "10-20 features"
    final rangeMatch = rangePattern.firstMatch(userIntent);
    if (rangeMatch != null) {
      min = int.parse(rangeMatch.group(1)!);
      max = int.parse(rangeMatch.group(2)!);
      target = ((min + max) / 2).round();
    }
    // Try "exactly N"
    else if (exactlyPattern.hasMatch(userIntent)) {
      final match = exactlyPattern.firstMatch(userIntent)!;
      target = int.parse(match.group(1)!);
      min = target;
      max = target;
    }
    // Try "at least N"
    else if (atLeastPattern.hasMatch(userIntent)) {
      final match = atLeastPattern.firstMatch(userIntent)!;
      min = int.parse(match.group(1)!);
      target = min + 5; // Add buffer
      max = null; // No upper bound
    }
    // Try single number: "30 items"
    else if (singlePattern.hasMatch(userIntent)) {
      final match = singlePattern.firstMatch(userIntent)!;
      target = int.parse(match.group(1)!);
      min = target;
      max = target;
    }
    // No numbers found - use defaults based on action
    else {
      target = action == 'expand' ? 15 : (action == 'simplify' ? 5 : 10);
      min = null;
      max = null;
    }
    
    // Extract verb hints
    if (userIntent.toLowerCase().contains('add')) verb = 'add';
    if (userIntent.toLowerCase().contains('expand')) verb = 'expand';
    if (userIntent.toLowerCase().contains('simplify')) verb = 'simplify';
    if (userIntent.toLowerCase().contains('rewrite')) verb = 'rewrite';
    
    return IntentParser(
      action: action,
      minCount: min,
      maxCount: max,
      targetCount: target,
      verb: verb,
      cleanedIntent: userIntent,
    );
  }

  bool isCountSpecified() => minCount != null || maxCount != null;
  
  String getCountConstraint() {
    if (minCount != null && maxCount != null) {
      if (minCount == maxCount) {
        return 'EXACTLY $minCount items';
      }
      return 'BETWEEN $minCount AND $maxCount items';
    }
    if (minCount != null) {
      return 'AT LEAST $minCount items';
    }
    if (maxCount != null) {
      return 'AT MOST $maxCount items';
    }
    return 'APPROXIMATELY $targetCount items';
  }
}
