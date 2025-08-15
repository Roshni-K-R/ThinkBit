abstract class FollowState {}

class FollowInitial extends FollowState {}

class FollowLoading extends FollowState {}

class FollowStatusLoaded extends FollowState {
  final Set<String> followingUserIds;

  FollowStatusLoaded({required this.followingUserIds});
}
class FollowSuccess extends FollowState {
  final String targetUserId;

  FollowSuccess({required this.targetUserId});
}

class UnfollowSuccess extends FollowState {
  final String targetUserId;

  UnfollowSuccess({required this.targetUserId});
}

class FollowError extends FollowState {
  final String message;

  FollowError(this.message);
}
