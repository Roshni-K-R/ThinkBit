import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_profile.dart';
import '../../../follow/domain/usecase/follower_count_usecase.dart';
import '../../../follow/domain/usecase/following_count_usecase.dart';
import '../../domain/usecases/get_post_count.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final GetPostCount getUserPostCount;
  final StreamFollowerCountUseCase followerUseCase;
  final StreamFollowingCountUseCase followingUseCase;

  StreamSubscription<int>? _followerSub;
  StreamSubscription<int>? _followingSub;

  @override
  Future<void> close() {
    _followerSub?.cancel();
    _followingSub?.cancel();
    return super.close();
  }


  ProfileBloc(
      this.getUserProfile,
      this.updateUserProfile,
      this.getUserPostCount,
      this.followerUseCase,
      this.followingUseCase,
      ) : super(ProfileInitial()) {
    //load profile
    on<LoadUserProfile>((event, emit) async {
      emit(ProfileLoading());

      try {
        final count = await getUserPostCount(event.userId); // 🔹 Get post count first

        await emit.forEach<UserProfile>(
          getUserProfile(event.userId),
          onData: (profile) {
            add(StreamFollowerCount(event.userId));
            add(StreamFollowingCount(event.userId));
            return ProfileLoaded(profile, postCount: count,); // 🔹 Now this is sync
          },
          onError: (error, stackTrace) => ProfileError(error.toString()),
        );
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    //load post count
    on<LoadUserPostCount>((event, emit) async {
      try {
        final count = await getUserPostCount(event.userId);
        final currentState = state;
        if (currentState is ProfileLoaded) {
          emit(ProfileLoaded(currentState.profile, postCount: count));
        }
      } catch (e) {
        emit(ProfileError("Failed to fetch post count: $e"));
      }
    });

    //updateProfile
    on<UpdateUserProfileEvent>((event, emit) async {
      try {
        await updateUserProfile(event.profile);
        if (!emit.isDone) {
          emit(ProfileUpdated());
        }

        await emit.forEach<UserProfile>(
          getUserProfile(event.profile.id),
          onData: (profile) => ProfileLoaded(profile),
          onError: (error, _) => ProfileError(error.toString()),
        );
      } catch (e) {
        if (!emit.isDone) {
          emit(ProfileError(e.toString()));
        }
      }
    });

    // ✅ 4. Follower Count
    on<UpdateFollowerCount>((event, emit) {
      if (state is ProfileLoaded) {
        emit((state as ProfileLoaded).copyWith(followerCount: event.count));
      }
    });

    // ✅ 5. Following Count
    on<UpdateFollowingCount>((event, emit) {
      if (state is ProfileLoaded) {
        emit((state as ProfileLoaded).copyWith(followingCount: event.count));
      }
    });

    // ✅ 6. Stream Follower Count
    on<StreamFollowerCount>((event, emit) {
      _followerSub?.cancel();
      _followerSub = followerUseCase(event.userId).listen((count) {
        add(UpdateFollowerCount(count));
      });
    });

    // ✅ 7. Stream Following Count
    on<StreamFollowingCount>((event, emit) {
      _followingSub?.cancel();
      _followingSub = followingUseCase(event.userId).listen((count) {
        add(UpdateFollowingCount(count));
      });
    });
  }
}
