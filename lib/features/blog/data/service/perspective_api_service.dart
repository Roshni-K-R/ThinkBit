import 'dart:convert';
import 'package:http/http.dart' as http;

class PerspectiveApiService {
  final String _apiKey;

  PerspectiveApiService(this._apiKey);

  Future<Map<String, double>> analyzeText(String text) async {
    final url = Uri.parse(
      'https://commentanalyzer.googleapis.com/v1alpha1/comments:analyze?key=$_apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'comment': {'text': text},
        'languages': ['en'],
        'requestedAttributes': {
          'TOXICITY': {},
          'INSULT': {},
          'PROFANITY': {}
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return {
        'toxicity': data['attributeScores']['TOXICITY']['summaryScore']['value'] ?? 0.0,
        'insult': data['attributeScores']['INSULT']['summaryScore']['value'] ?? 0.0,
        'profanity': data['attributeScores']['PROFANITY']['summaryScore']['value'] ?? 0.0,
      };
    } else {
      throw Exception(
        'Perspective API failed: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
