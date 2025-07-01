import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;

  ProfileBloc(this.getUserProfile, this.updateUserProfile) : super(ProfileInitial()) {
    on<LoadUserProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        await emit.forEach<UserProfile>(
          getUserProfile(event.userId),
          onData: (profile) => ProfileLoaded(profile),
          onError: (error, stackTrace) => ProfileError(error.toString()),
        );
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });



    on<UpdateUserProfileEvent>((event, emit) async {
      try {
        await updateUserProfile(event.profile);

        // 👇 Only emit if still active
        if (!emit.isDone) {
          emit(ProfileUpdated());
        }

        // 👇 Re-load profile safely inside same handler
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
