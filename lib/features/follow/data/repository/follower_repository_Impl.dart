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


  @override
  Future<void> followUser(String followerId, String followingId) async {
    print("📥 Inserting into followers table...");
    try {
      await client.from('followers').insert({
        'follower_id': followerId,
        'following_id': followingId,
      });
      print("✅ Inserted into followers table");
    } catch (e) {
      print("❌ Insert failed: $e");
      rethrow; // ❗️Re-throw so Bloc knows it failed
    }
  }


  @override
  Future<void> unfollowUser(String followerId, String followingId) async {
    print("🧪 Trying to unfollow: followerId=$followerId, followingId=$followingId");

    try {
      final response = await client
          .from('followers')
          .delete()
          .match({
        'follower_id': followerId,
        'following_id': followingId,
      });

      print("🗑️ Unfollow response: $response");
    } catch (e) {
      print("❌ Error while unfollowing: $e");
      rethrow;
    }
  }


  @override
  Future<bool> isFollowing(String followerId, String followingId) async {
    final result = await client
        .from('followers')
        .select()
        .eq('follower_id', followerId)
        .eq('following_id', followingId)
        .maybeSingle();

    return result != null;
  }

  @override
  Future<List<String>> getFollowingUserIds(String userId) async {
    final response = await client
        .from('followers')
        .select('following_id')
        .eq('follower_id', userId);

    // Extract all following_id values into a list
    return (response as List)
        .map((item) => item['following_id'] as String)
        .toList();
  }


}
