// discover_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_users_except_current.dart';
import 'discover_event.dart';
import 'discover_state.dart';

// discover_bloc.dart
class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final GetAllUsersExceptCurrentUsecase getAllUsersExceptCurrent;

  DiscoverBloc(this.getAllUsersExceptCurrent) : super(DiscoverInitial()) {
    on<LoadAllUsersExceptCurrent>((event, emit) async {
      emit(DiscoverLoading());
      final result = await getAllUsersExceptCurrent(event.currentUserId);
      result.fold(
            (failure) => emit(DiscoverError(failure.message)),
            (users) {
          // Preserve existing followingStatus with proper typing
          final currentStatus = state is DiscoverLoaded
              ? (state as DiscoverLoaded).followingStatus
              : <String, bool>{};

          // Initialize new status map with proper typing
          final newStatus = <String, bool>{};

          // Copy existing status
          newStatus.addAll(currentStatus);

          // Initialize status for new users
          for (final user in users) {
            newStatus.putIfAbsent(user.id, () => false);
          }

          emit(DiscoverLoaded(
            users: users,
            followingStatus: newStatus,
          ));
        },
      );
    });
    on<UpdateFollowingStatusInDiscover>((event, emit) {
      if (state is DiscoverLoaded) {
        final currentState = state as DiscoverLoaded;
        final updatedStatus = Map<String, bool>.from(currentState.followingStatus);
        updatedStatus[event.targetUserId] = event.isFollowing;
        emit(currentState.copyWith(followingStatus: updatedStatus));
      }
    });

    on<SyncFollowingStatusEvent>((event, emit) {
      if (state is DiscoverLoaded) {
        final currentState = state as DiscoverLoaded;
        final updatedStatus = <String, bool>{};
        for (var user in currentState.users) {
          updatedStatus[user.id] = event.followingUserIds.contains(user.id);
        }
        emit(currentState.copyWith(followingStatus: updatedStatus));
      }
    });

    on<ClearDiscoverState>((event, emit) {
      emit(DiscoverInitial());
    });
  }
}