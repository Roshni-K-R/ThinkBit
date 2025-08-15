import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../follow/presentation/bloc/follow_bloc.dart';
import '../../../follow/presentation/bloc/follow_event.dart';
import '../../../follow/presentation/bloc/follow_state.dart';
import '../bloc/discover_bloc.dart';
import '../bloc/discover_event.dart';
import '../bloc/discover_state.dart';

class DiscoverUserList extends StatefulWidget {
  final String currentUserId;

  const DiscoverUserList({super.key, required this.currentUserId});

  @override
  State<DiscoverUserList> createState() => _DiscoverUserListState();
}

class _DiscoverUserListState extends State<DiscoverUserList> {
  bool _hasLoadedFollowStatus = false;
  bool _hasSyncedStatus = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ Clear discover state to avoid stale data
    context.read<DiscoverBloc>().add(ClearDiscoverState());

    // ✅ Load follow data once when re-entering the widget
    if (!_hasLoadedFollowStatus) {
      context.read<FollowBloc>().add(LoadFollowingUsersEvent(widget.currentUserId));
      _hasLoadedFollowStatus = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowBloc, FollowState>(
      builder: (context, followState) {
        if (followState is FollowStatusLoaded && !_hasSyncedStatus) {
          context.read<DiscoverBloc>().add(SyncFollowingStatusEvent(followState.followingUserIds));
          context.read<FollowBloc>().add(LoadFollowingUsersEvent(widget.currentUserId)); // Assuming you have this
          _hasSyncedStatus = true;
        }

        return BlocBuilder<DiscoverBloc, DiscoverState>(
          builder: (context, discoverState) {
            if (discoverState is DiscoverLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (discoverState is DiscoverLoaded) {
              return ListView.builder(
                itemCount: discoverState.users.length,
                itemBuilder: (context, index) {
                  final user = discoverState.users[index];
                  final isFollowing = discoverState.followingStatus[user.id] ?? false;

                  return ListTile(
                    leading: CircleAvatar(child: Text(user.name[0])),
                    title: Text(user.name),
                    subtitle: Text("ID: ${user.id}"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        final followBloc = context.read<FollowBloc>();

                        if (isFollowing) {
                          followBloc.add(UnfollowUserEvent(
                            currentUserId: widget.currentUserId,
                            targetUserId: user.id,
                          ));
                        } else {
                          followBloc.add(FollowUserEvent(
                            currentUserId: widget.currentUserId,
                            targetUserId: user.id,
                          ));
                        }

                        // ✅ Immediately update Discover UI locally
                        context.read<DiscoverBloc>().add(
                          UpdateFollowingStatusInDiscover(
                            targetUserId: user.id,
                            isFollowing: !isFollowing,
                          ),
                        );
                      },
                      child: Text(isFollowing ? 'Following' : 'Follow'),
                    ),
                  );
                },
              );
            } else if (discoverState is DiscoverError) {
              return Center(child: Text("Error: ${discoverState.message}"));
            } else {
              return const Center(child: Text("No users found."));
            }
          },
        );
      },
    );
  }
}
