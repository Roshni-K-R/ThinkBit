import '../entities/user_profile.dart';
import '../repository/profile_repository.dart';

class GetUserProfile {
  final ProfileRepository repo;

  GetUserProfile(this.repo);

  Stream<UserProfile> call(String userId) => repo.getProfile(userId);
}
