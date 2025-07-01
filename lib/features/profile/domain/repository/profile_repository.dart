import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Stream<UserProfile> getProfile(String userId);
  Future<void> updateProfile(UserProfile profile);
}
