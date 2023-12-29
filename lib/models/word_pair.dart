class WordPair {
  final String wordA;
  final String wordB;

  WordPair(this.wordA, this.wordB);

  // Convert a WordPair instance into a Map.
  Map<String, dynamic> toJson() {
    return {
      'wordA': wordA,
      'wordB': wordB,
    };
  }

  // Convert a Map into a WordPair instance.
  static WordPair fromJson(Map<String, dynamic> json) {
    return WordPair(
      json['wordA'] as String,
      json['wordB'] as String,
    );
  }
}
