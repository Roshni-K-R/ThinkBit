import '../../domain/entities/user_profile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

// class ProfileLoaded extends ProfileState {
//   final UserProfile profile;
//   ProfileLoaded(this.profile);
// }
class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  final int postCount;

  ProfileLoaded(this.profile, {this.postCount = 0});
}


class ProfileUpdated extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
