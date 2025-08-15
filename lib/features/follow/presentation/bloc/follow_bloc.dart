import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../discover_users/presentation/bloc/discover_bloc.dart';
import '../../../discover_users/presentation/bloc/discover_event.dart';
import '../../domain/usecase/check_follow_status.dart';
import '../../domain/usecase/follow_user_usecase.dart';
import '../../domain/usecase/unfollow_user_usecase.dart';
import 'follow_event.dart';
import 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final FollowUserUseCase followUser;
  final UnfollowUserUseCase unfollowUser;
  // final CheckFollowingStatusUseCase checkFollowingStatus;
  final GetAllFollowingUseCase getAllFollowingUseCase;

  FollowBloc({
    required this.followUser,
    required this.unfollowUser,
    required this.getAllFollowingUseCase,
   // required this.checkFollowingStatus,
  }) : super(FollowInitial()) {
    on<FollowUserEvent>((event, emit) async {
      print("🔄 FollowUserEvent received for ${event.targetUserId}");
      try {
        print("📍 Trying to insert follow...");
        await followUser(event.currentUserId, event.targetUserId);
        print("✅ FollowUserUseCase completed");

        Set<String> updatedUserIds = {};
        if (state is FollowStatusLoaded) {
          updatedUserIds = Set<String>.from(
            (state as FollowStatusLoaded).followingUserIds,
          );
        }

        updatedUserIds.add(event.targetUserId);

        emit(FollowStatusLoaded(followingUserIds: updatedUserIds));

        // ✅ Notify UI of success (optional if you're using it)
        emit(FollowSuccess(targetUserId: event.targetUserId));

        // ✅ Sync with DiscoverBloc so its UI updates too
        if (emit is Emitter) {
          // This is only valid if you have context, or make it part of a method where context is available
          // So best move this to the DiscoverUserList if you can't access context here
          // OR trigger an external event via another BLoC listener.
        }
      } catch (e) {
        print("❌ Error inserting follow: $e");
        emit(FollowError("Failed to follow user: ${e.toString()}"));
      }

      print("✅ End of FollowUserEvent handler");
    });



    on<LoadFollowingUsersEvent>((event, emit) async {
      try {
        final userIds = await getAllFollowingUseCase(event.currentUserId);
        emit(FollowStatusLoaded(followingUserIds: userIds.toSet()));
        add(SyncFollowingStatusEvent(userIds.toSet()) as FollowEvent);
      } catch (e) {
        emit(FollowError("Failed to load follow list"));
      }
    });


    on<UnfollowUserEvent>((event, emit) async {
      print("❌ UnfollowUserEvent received for ${event.targetUserId}");
      try {
        await unfollowUser(event.currentUserId, event.targetUserId);
        print("✅ Unfollowed in backend");

        Set<String> updatedUserIds = {};
        if (state is FollowStatusLoaded) {
          updatedUserIds = Set<String>.from((state as FollowStatusLoaded).followingUserIds);
        }

        updatedUserIds.remove(event.targetUserId);
        emit(FollowStatusLoaded(followingUserIds: updatedUserIds));
        emit(UnfollowSuccess(targetUserId: event.targetUserId));
      } catch (e) {
        emit(FollowError("Failed to unfollow: $e"));
      }

      print("✅ End of UnfollowUserEvent handler");
    });


  }
}
