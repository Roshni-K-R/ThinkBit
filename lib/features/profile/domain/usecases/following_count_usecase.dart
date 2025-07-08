import '../repository/follower_repository.dart';

class StreamFollowingCountUseCase {
  final FollowerRepository repository;

  StreamFollowingCountUseCase(this.repository);

  Stream<int> call(String userId) {
    return repository.getFollowingCountStream(userId);
  }
}
