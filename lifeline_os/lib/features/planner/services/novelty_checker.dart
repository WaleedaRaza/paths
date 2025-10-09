/// Utility for checking novelty and similarity between text versions
/// Uses trigram Jaccard similarity to detect repetitive content
class NoveltyChecker {
  /// Compute Jaccard similarity using trigrams (word triplets)
  /// Returns 0.0 (completely different) to 1.0 (identical)
  static double jaccardTrigram(String textA, String textB) {
    final tokensA = textA.toLowerCase().split(RegExp(r'\s+'));
    final tokensB = textB.toLowerCase().split(RegExp(r'\s+'));
    
    final trigramsA = _extractTrigrams(tokensA);
    final trigramsB = _extractTrigrams(tokensB);
    
    if (trigramsA.isEmpty && trigramsB.isEmpty) return 0.0;
    if (trigramsA.isEmpty || trigramsB.isEmpty) return 0.0;
    
    final intersection = trigramsA.intersection(trigramsB);
    final union = trigramsA.union(trigramsB);
    
    return intersection.length / union.length;
  }

  static Set<String> _extractTrigrams(List<String> tokens) {
    final trigrams = <String>{};
    for (var i = 0; i < tokens.length - 2; i++) {
      trigrams.add('${tokens[i]} ${tokens[i + 1]} ${tokens[i + 2]}');
    }
    return trigrams;
  }

  /// Extract most common trigrams for forbidding in regeneration
  static List<String> getTopTrigrams(String text, int count) {
    final tokens = text.toLowerCase().split(RegExp(r'\s+'));
    final trigramCounts = <String, int>{};
    
    for (var i = 0; i < tokens.length - 2; i++) {
      final trigram = '${tokens[i]} ${tokens[i + 1]} ${tokens[i + 2]}';
      trigramCounts[trigram] = (trigramCounts[trigram] ?? 0) + 1;
    }
    
    final sorted = trigramCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(count).map((e) => e.key).toList();
  }

  /// Check if new content is novel enough compared to original
  static bool isNovelEnough(
    String original,
    List<String> newLines,
    double threshold,
  ) {
    final newText = newLines.join('\n');
    final similarity = jaccardTrigram(original, newText);
    print('Novelty check: similarity = $similarity, threshold = $threshold');
    return similarity < threshold;
  }
}
