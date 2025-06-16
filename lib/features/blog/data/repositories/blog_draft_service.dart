import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DraftService {
  static Future<void> saveDraft({
    required String userId,
    required String? title,
    required String? content,
    required List<String> topics,
    required String? imagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('blog_draft_$userId', jsonEncode({
      'title': title,
      'content': content,
      'topics': topics,
      'imagePath': imagePath,
      'userId': userId,
    }));
  }

  static Future<Map<String, dynamic>?> loadDraft(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final draftJson = prefs.getString('blog_draft_$userId');
    if (draftJson == null) return null;

    final draft = jsonDecode(draftJson);
    return draft['userId'] == userId ? draft : null;
  }

  static Future<void> clearDraft(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('blog_draft_$userId');
  }
}