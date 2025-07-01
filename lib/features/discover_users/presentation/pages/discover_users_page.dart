import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../init_dependencies.dart';
import '../../domain/usecases/get_all_users_except_current.dart';
import '../bloc/discover_bloc.dart';
import '../bloc/discover_event.dart';
import '../bloc/discover_state.dart';

class DiscoverUsersPage extends StatelessWidget {
  const DiscoverUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user;

    return Scaffold(
      appBar: AppBar(title: const Text("Discover Users")),
      body: BlocProvider(
        create: (context) {
          final bloc = DiscoverBloc(serviceLocator<GetAllUsersExceptCurrentUsecase>());
          bloc.add(LoadAllUsersExceptCurrent(currentUser.id)); // Updated event name
          return bloc;
        },
        child: BlocBuilder<DiscoverBloc, DiscoverState>(
          builder: (context, state) {
            if (state is DiscoverLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DiscoverLoaded) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(user.name[0])),
                    title: Text(user.name),
                    subtitle: Text("ID: ${user.id}"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Handle follow logic
                      },
                      child: const Text("Follow"),
                    ),
                  );
                },
              );
            } else if (state is DiscoverError) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return const Center(child: Text("No users found."));
            }
          },
        ),
      ),
    );
  }
}