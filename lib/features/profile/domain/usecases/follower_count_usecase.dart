import '../repository/follower_repository.dart';

class StreamFollowerCountUseCase {
  final FollowerRepository repository;

  StreamFollowerCountUseCase(this.repository);

  Stream<int> call(String userId) {
    return repository.getFollowerCountStream(userId);
  }
}
