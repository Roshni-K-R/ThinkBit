// discover_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_all_users_except_current.dart';
import 'discover_event.dart';
import 'discover_state.dart';

// discover_bloc.dart
class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final GetAllUsersExceptCurrentUsecase getAllUsersExceptCurrent;

  DiscoverBloc(this.getAllUsersExceptCurrent) : super(DiscoverInitial()) {
    // Properly typed event handler
    on<LoadAllUsersExceptCurrent>((event, emit) async {
      emit(DiscoverLoading());
      final result = await getAllUsersExceptCurrent(event.currentUserId);
      result.fold(
            (failure) => emit(DiscoverError(failure.message)),
            (users) => emit(DiscoverLoaded(users)),
      );
    });
  }
}