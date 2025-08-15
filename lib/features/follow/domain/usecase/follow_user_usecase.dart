import '../repository/follower_repository.dart';

class FollowUserUseCase {
  final FollowerRepository repository;

  FollowUserUseCase(this.repository);

  Future<void> call(String followerId, String followingId) async {
    print("🔁 Inside FollowUserUseCase: start");
    await repository.followUser(followerId, followingId);
    print("✅ Inside FollowUserUseCase: end");
  }
}
