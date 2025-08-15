import '../repository/follower_repository.dart';

class UnfollowUserUseCase {
  final FollowerRepository repository;

  UnfollowUserUseCase(this.repository);

  Future<void> call(String followerId, String followingId) {
    return repository.unfollowUser(followerId, followingId);
  }
}
