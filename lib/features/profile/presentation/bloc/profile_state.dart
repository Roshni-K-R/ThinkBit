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
  final int followerCount;
  final int followingCount;

  ProfileLoaded(
      this.profile, {
        this.postCount = 0,
        this.followerCount = 0,
        this.followingCount = 0,
      });

  ProfileLoaded copyWith({
    UserProfile? profile,
    int? postCount,
    int? followerCount,
    int? followingCount,
  }) {
    return ProfileLoaded(
      profile ?? this.profile,
      postCount: postCount ?? this.postCount,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
    );
  }
}


class ProfileUpdated extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
