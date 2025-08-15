abstract class FollowerRepository {
  Stream<int> getFollowerCountStream(String userId);
  Stream<int> getFollowingCountStream(String userId);
  Future<void> followUser(String followerId, String followingId);
  Future<void> unfollowUser(String followerId, String followingId);
  //Future<bool> isFollowing(String followerId, String followingId);
  Future<List<String>> getFollowingUserIds(String userId);
}