import '../repository/profile_repository.dart';

class GetPostCount {
  final ProfileRepository repository;

  GetPostCount(this.repository);

  Future<int> call(String userId) {
    return repository.getPostCount(userId);
  }
}
