import 'package:equatable/equatable.dart';

abstract class FollowEvent extends Equatable {
  const FollowEvent();

  @override
  List<Object> get props => [];
}

/// 🔄 Follow a user
class FollowUserEvent extends FollowEvent {
  final String currentUserId;
  final String targetUserId;

  const FollowUserEvent({
    required this.currentUserId,
    required this.targetUserId,
  });

  @override
  List<Object> get props => [currentUserId, targetUserId];
}

/// ❌ Unfollow a user
class UnfollowUserEvent extends FollowEvent {
  final String currentUserId;
  final String targetUserId;

  const UnfollowUserEvent({
    required this.currentUserId,
    required this.targetUserId,
  });

  @override
  List<Object> get props => [currentUserId, targetUserId];
}

/// 👁️ Check if current user follows another user
class CheckFollowingStatusEvent extends FollowEvent {
  final String currentUserId;
  final String targetUserId;

  const CheckFollowingStatusEvent({
    required this.currentUserId,
    required this.targetUserId,
  });

  @override
  List<Object> get props => [currentUserId, targetUserId];
}
/// 📥 Load all users the current user is following
class LoadFollowingUsersEvent extends FollowEvent {
  final String currentUserId;

  const LoadFollowingUsersEvent(this.currentUserId);

  @override
  List<Object> get props => [currentUserId];
}
