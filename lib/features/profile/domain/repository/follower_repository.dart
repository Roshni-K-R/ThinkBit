abstract class FollowerRepository {
  Stream<int> getFollowerCountStream(String userId);
  Stream<int> getFollowingCountStream(String userId);
}