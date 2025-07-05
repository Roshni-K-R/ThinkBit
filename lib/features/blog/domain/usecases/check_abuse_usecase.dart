import '../repository/abuse_check_repository.dart';

class CheckAbuseUseCase {
  final AbuseCheckRepository repository;

  CheckAbuseUseCase(this.repository);

  /// Returns true if content is abusive based on thresholds
  Future<bool> call(String content) async {
    return await repository.isContentAbusive(content);
  }

  /// Optional: get raw scores to show in UI or logs
  Future<Map<String, double>> getScores(String content) async {
    return await repository.getRawAbuseScores(content);
  }
}
