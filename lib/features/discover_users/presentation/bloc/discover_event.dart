// features/discover/presentation/bloc/discover_event.dart

import 'package:equatable/equatable.dart';

// discover_event.dart
abstract class DiscoverEvent {}

class LoadAllUsersExceptCurrent extends DiscoverEvent {
  final String currentUserId;

  LoadAllUsersExceptCurrent(this.currentUserId);
}