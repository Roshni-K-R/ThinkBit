import '../../domain/entities/user_profile.dart';

abstract class ProfileEvent {}

class LoadUserProfile extends ProfileEvent {
  final String userId;
  LoadUserProfile(this.userId);
}

class UpdateUserProfileEvent extends ProfileEvent {
  final UserProfile profile;
  UpdateUserProfileEvent(this.profile);
}

// class GetProfileEvent extends ProfileEvent {
//   final String userId;
//   GetProfileEvent(this.userId);
// }
class LoadUserPostCount extends ProfileEvent {
  final String userId;
  LoadUserPostCount(this.userId);
}

