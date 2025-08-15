import '../repository/follower_repository.dart';

class GetAllFollowingUseCase {
  final FollowerRepository repository;

  GetAllFollowingUseCase(this.repository);

  Future<Set<String>> call(String currentUserId) async {
    final list = await repository.getFollowingUserIds(currentUserId);
    return list.toSet(); // use Set for fast lookup in UI
  }
}

