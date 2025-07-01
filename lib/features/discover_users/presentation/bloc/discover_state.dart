// features/discover/presentation/bloc/discover_state.dart

import 'package:equatable/equatable.dart';

import '../../../profile/domain/entities/user_profile.dart';


// discover_state.dart
abstract class DiscoverState {}

class DiscoverInitial extends DiscoverState {}

class DiscoverLoading extends DiscoverState {}

// discover_state.dart
class DiscoverLoaded extends DiscoverState {
  final List<UserProfile> users;  // Should expect a List<UserProfile>

  DiscoverLoaded(this.users);
}
class DiscoverError extends DiscoverState {
  final String message;

  DiscoverError(this.message);
}