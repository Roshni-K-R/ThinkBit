import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_post_count.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final GetPostCount getUserPostCount;

  ProfileBloc(
      this.getUserProfile,
      this.updateUserProfile,
      this.getUserPostCount,
      ) : super(ProfileInitial()) {
    on<LoadUserProfile>((event, emit) async {
      emit(ProfileLoading());

      try {
        final count = await getUserPostCount(event.userId); // 🔹 Get post count first

        await emit.forEach<UserProfile>(
          getUserProfile(event.userId),
          onData: (profile) {
            return ProfileLoaded(profile, postCount: count); // 🔹 Now this is sync
          },
          onError: (error, stackTrace) => ProfileError(error.toString()),
        );
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });


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
  }
}
