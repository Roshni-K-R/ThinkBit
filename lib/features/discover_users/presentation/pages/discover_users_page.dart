import 'package:ThinkBit/features/discover_users/presentation/pages/discover_user_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ThinkBit/core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../init_dependencies.dart';
import '../../../follow/domain/usecase/check_follow_status.dart';
import '../../../follow/domain/usecase/follow_user_usecase.dart';
import '../../../follow/domain/usecase/unfollow_user_usecase.dart';
import '../../../follow/presentation/bloc/follow_bloc.dart';
import '../../../follow/presentation/bloc/follow_event.dart';
import '../../../follow/presentation/bloc/follow_state.dart';
import '../../domain/usecases/get_all_users_except_current.dart';
import '../bloc/discover_bloc.dart';
import '../bloc/discover_event.dart';


class DiscoverUsersPage extends StatefulWidget {
  const DiscoverUsersPage({super.key, required this.currentUserId});

  final String currentUserId;

  @override
  State<DiscoverUsersPage> createState() => _DiscoverUsersPageState();
}

class _DiscoverUsersPageState extends State<DiscoverUsersPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Discover Users")),
      body: MultiBlocProvider(
        providers: [
          // ✅ Provide FollowBloc
          BlocProvider<FollowBloc>(
            create: (context) => FollowBloc(
              followUser: serviceLocator<FollowUserUseCase>(),
              unfollowUser: serviceLocator<UnfollowUserUseCase>(),
              getAllFollowingUseCase: serviceLocator<GetAllFollowingUseCase>(),
            )..add(LoadFollowingUsersEvent(widget.currentUserId)), // load follow list
          ),

          // ✅ Provide DiscoverBloc
          BlocProvider<DiscoverBloc>(
            create: (context) => DiscoverBloc(
              serviceLocator<GetAllUsersExceptCurrentUsecase>(),
            )..add(LoadAllUsersExceptCurrent(widget.currentUserId)), // load users
          ),
        ],
        child: DiscoverUserList(currentUserId: widget.currentUserId),
      ),
    );
  }
}
