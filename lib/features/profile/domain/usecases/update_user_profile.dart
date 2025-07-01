import '../entities/user_profile.dart';
import '../repository/profile_repository.dart';

class UpdateUserProfile {
  final ProfileRepository repo;

  UpdateUserProfile(this.repo);

  Future<void> call(UserProfile profile) => repo.updateProfile(profile);
}
