abstract class AbuseCheckRepository {
  /// Returns true if content is abusive based on Perspective API scores
  Future<bool> isContentAbusive(String content);

  /// Optionally return the raw score values if you want to display/toast them
  Future<Map<String, double>> getRawAbuseScores(String content);
}
