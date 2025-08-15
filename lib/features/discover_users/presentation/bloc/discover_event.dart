// features/discover/presentation/bloc/discover_event.dart

import 'package:equatable/equatable.dart';

// discover_event.dart
abstract class DiscoverEvent {}

class LoadAllUsersExceptCurrent extends DiscoverEvent {
  final String currentUserId;

  LoadAllUsersExceptCurrent(this.currentUserId);
}
class UpdateFollowingStatusInDiscover extends DiscoverEvent {
  final String targetUserId;
  final bool isFollowing;

  UpdateFollowingStatusInDiscover({
    required this.targetUserId,
    required this.isFollowing,
  });

  @override
  List<Object> get props => [targetUserId, isFollowing];
}

/// 🔄 Used to sync current follow status to DiscoverBloc
class SyncFollowingStatusEvent extends DiscoverEvent {
  final Set<String> followingUserIds;

  SyncFollowingStatusEvent(this.followingUserIds);

  @override
  List<Object?> get props => [followingUserIds];
}

class ClearDiscoverState extends DiscoverEvent {}