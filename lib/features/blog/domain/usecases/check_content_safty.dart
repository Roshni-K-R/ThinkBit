import '../../../../core/utils/profanity_filter.dart';

class ContentSafetyCheck {
  final int currentWarnings;

  const ContentSafetyCheck(this.currentWarnings);

  ContentSafetyResult execute(String text) {
    final isOffensive = ProfanityFilter.containsProfanity(text);

    return isOffensive
        ? ContentSafetyResult.offensive(currentWarnings + 1)
        : ContentSafetyResult.safe();
  }
}

class ContentSafetyResult {
  final bool isSafe;
  final int warningCount;

  const ContentSafetyResult._({required this.isSafe, this.warningCount = 0});

  factory ContentSafetyResult.safe() => const ContentSafetyResult._(isSafe: true);
  factory ContentSafetyResult.offensive(int warnings) =>
      ContentSafetyResult._(isSafe: false, warningCount: warnings);
}