import '../../domain/repository/abuse_check_repository.dart';
import '../service/perspective_api_service.dart';

class AbuseCheckRepositoryImpl implements AbuseCheckRepository {
  final PerspectiveApiService _apiService;



  // You can customize thresholds
  final double _toxicityThreshold;
  final double _insultThreshold;
  final double _profanityThreshold;


  AbuseCheckRepositoryImpl(
      this._apiService, {
        double toxicityThreshold = 0.4,
        double insultThreshold = 0.4,
        double profanityThreshold = 0.4,
      })  : _toxicityThreshold = toxicityThreshold,
        _insultThreshold = insultThreshold,
        _profanityThreshold = profanityThreshold;

  @override
  Future<bool> isContentAbusive(String content) async {


    final scores = await _apiService.analyzeText(content);

    return scores.values.any((score) => score > 0.4); // ⚠️ Block anything flagg
    // ed even slightly
  }


  @override
  Future<Map<String, double>> getRawAbuseScores(String content) async {
    return await _apiService.analyzeText(content);
  }
}
