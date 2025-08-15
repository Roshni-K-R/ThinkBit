import 'package:equatable/equatable.dart';
import '../../../profile/domain/entities/user_profile.dart';

abstract class DiscoverState extends Equatable {
  const DiscoverState();

  @override
  List<Object> get props => [];
}

class DiscoverInitial extends DiscoverState {
  const DiscoverInitial();
}

class DiscoverLoading extends DiscoverState {
  const DiscoverLoading();
}

class DiscoverLoaded extends DiscoverState {
  final List<UserProfile> users;
  final Map<String, bool> followingStatus;

  const DiscoverLoaded({
    required this.users,
    required this.followingStatus,
  });

  DiscoverLoaded copyWith({
    List<UserProfile>? users,
    Map<String, bool>? followingStatus,
  }) {
    return DiscoverLoaded(
      users: users ?? this.users,
      followingStatus: followingStatus ?? this.followingStatus,
    );
  }

  @override
  List<Object> get props => [users, followingStatus];
}

class DiscoverError extends DiscoverState {
  final String message;

  const DiscoverError(this.message);

  @override
  List<Object> get props => [message];
}