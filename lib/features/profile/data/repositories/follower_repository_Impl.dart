import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repository/follower_repository.dart';

class FollowerRepositoryImpl implements FollowerRepository {
  final SupabaseClient client;

  FollowerRepositoryImpl(this.client);

  @override
  Stream<int> getFollowerCountStream(String userId) {
    return client
        .from('followers')
        .stream(primaryKey: ['follower_id', 'following_id'])
        .eq('following_id', userId)
        .execute()
        .timeout(const Duration(seconds: 5)) // ⏱️ Add timeout
        .handleError((e) {
      print("⚠️ Realtime subscription error: $e");
      return []; // Return empty if timeout
    })
        .map((data) => data.length);
  }


  @override
  Stream<int> getFollowingCountStream(String userId) {
    return client
        .from('followers')
        .stream(primaryKey: ['follower_id', 'following_id'])
        .eq('follower_id', userId)
        .execute()
        .map((data) => data.length);
  }
}
