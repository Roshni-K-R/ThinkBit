import 'package:ThinkBit/core/common/widgets/loader.dart';
import 'package:ThinkBit/core/theme/app_pallete.dart';
import 'package:ThinkBit/core/utils/show_snackbar.dart';
import 'package:ThinkBit/features/auth/presentation/pages/login_page.dart';
import 'package:ThinkBit/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:ThinkBit/features/blog/presentation/pages/add_blog_page.dart';
import 'package:ThinkBit/features/blog/presentation/widgets/blog_card.dart';
import 'package:ThinkBit/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../init_dependencies.dart';
import '../../../discover_users/domain/usecases/get_all_users_except_current.dart';
import '../../../discover_users/presentation/bloc/discover_bloc.dart';
import '../../../discover_users/presentation/bloc/discover_event.dart';
import '../../../discover_users/presentation/pages/discover_users_page.dart';
import '../../../follow/domain/usecase/check_follow_status.dart';
import '../../../follow/domain/usecase/follow_user_usecase.dart';
import '../../../follow/domain/usecase/follow_user_usecase.dart';
import '../../../follow/domain/usecase/unfollow_user_usecase.dart';
import '../../../follow/presentation/bloc/follow_bloc.dart';
import '../../../follow/presentation/bloc/follow_event.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../bloc/blog_state.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogGetAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        centerTitle: true,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.push(context, AddBlogPage.route());
        //   },
        //   icon: const Icon(CupertinoIcons.add_circled),
        // ),
        actions: [
          IconButton(
            onPressed: () {
              final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (_) => serviceLocator<ProfileBloc>()..add(LoadUserProfile(user.id)),
                    child: ProfilePage(userId: user.id),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.person),
          ),
          // IconButton(
          //   onPressed: () {
          //     final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
          //
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) {
          //           final currentUser = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
          //           return MultiBlocProvider(
          //             providers: [
          //               BlocProvider(
          //                 create: (_) => FollowBloc(
          //                   followUser: serviceLocator<FollowUserUseCase>(),
          //                   unfollowUser: serviceLocator<UnfollowUserUseCase>(),
          //                   getAllFollowingUseCase: serviceLocator<GetAllFollowingUseCase>(),
          //                 )..add(LoadFollowingUsersEvent(currentUser.id)),
          //               ),
          //               BlocProvider(
          //                 create: (_) => DiscoverBloc(
          //                   serviceLocator<GetAllUsersExceptCurrentUsecase>(),
          //                 )..add(LoadAllUsersExceptCurrent(currentUser.id)),
          //               ),
          //             ],
          //             child: DiscoverUsersPage(currentUserId: currentUser.id),
          //           );
          //         },
          //       ),
          //     );
          //
          //   },
          //   icon: const Icon(Icons.data_exploration_outlined),
          // ),
          IconButton(
            icon: Icon(Icons.person_search),
            tooltip: 'Discover Users',
            onPressed: () {
              final currentUserId = Supabase.instance.client.auth.currentUser?.id;

              if (currentUserId != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DiscoverUsersPage(currentUserId: currentUserId),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('You must be logged in to discover users.')),
                );
              }
            },
          ),

          IconButton(
            onPressed: () {
              // Add this to your logout functionality
              Future<void> _clearUserDrafts() async {
                final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('blog_draft_${user.id}');
              }
              // NOT THE BEST WAY = Just for testing
              // Proper way is to do using event by bloc or cubit where we call signout on supabase
              Navigator.pushAndRemoveUntil(
                context,
                LoginPage.route(),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),


        floatingActionButton: FloatingActionButton(
        // onPressed: () {
        //   Navigator.push(context, AddBlogPage.route());
        // },
        // Modify your FAB onPressed
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          final hasDraft = prefs.containsKey('blog_draft');

          if (hasDraft) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Recover Draft?'),
                content: const Text('You have an unsaved draft. Would you like to continue editing it?'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await prefs.remove('blog_draft');
                      Navigator.pop(context);
                      Navigator.push(context, AddBlogPage.route());
                    },
                    child: const Text('Start New'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, AddBlogPage.route());
                    },
                    child: const Text('Continue Draft'),
                  ),
                ],
              ),
            );
          } else {
            Navigator.push(context, AddBlogPage.route());
          }
        },
        backgroundColor: AppPallete.gradient1, // Use your app's primary color
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(
                  blog: blog,
                  color: index % 2 == 0
                      ? AppPallete.gradient1
                      : AppPallete.gradient2,
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
