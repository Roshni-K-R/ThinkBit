class ProfanityFilter {
  static const List<String> offensiveWords = [
    'badword1', 'badword2',
    // Add from: https://www.cs.cmu.edu/~biglou/resources/bad-words.txt
  ];

  static bool containsProfanity(String text) {
    final lowercaseText = text.toLowerCase();
    return offensiveWords.any((word) =>
        RegExp(r'\b' + word + r'\b', caseSensitive: false).hasMatch(lowercaseText));
  }
}