import 'dart:io';

import 'package:ThinkBit/features/profile/domain/usecases/get_post_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/utils/block_checker.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/edit_profile_panel.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats.dart';


class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  bool _isEditing = false;
  late AnimationController _animationController;
  late Animation<double> _editPanelAnimation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _editPanelAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    context.read<ProfileBloc>().add(LoadUserProfile(widget.userId));
    context.read<ProfileBloc>().add(LoadUserPostCount(widget.userId));
    context.read<ProfileBloc>().add(StreamFollowerCount(widget.userId));
    context.read<ProfileBloc>().add(StreamFollowingCount(widget.userId));

  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }


  void _toggleEditMode([File? newImage]) async {
    if (_isEditing) {
      String? avatarUrl;

      try {
        // 📦 Upload image if user selected a new one
        if (newImage != null) {
          final fileName = 'avatars/${widget.userId}_${DateTime.now().millisecondsSinceEpoch}.png';

          final bytes = await newImage.readAsBytes();
          final storageResponse = await Supabase.instance.client.storage
              .from('avatars')
              .uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

          // ✅ Get public URL
          avatarUrl = Supabase.instance.client.storage
              .from('avatars')
              .getPublicUrl(fileName);
        }

        // 🔄 Update profile
        context.read<ProfileBloc>().add(
          UpdateUserProfileEvent(
            UserProfile(
              id: widget.userId,
              name: _nameController.text.trim(),
              bio: _bioController.text.trim(),
              avatarUrl: avatarUrl, // optional: if null, avatar stays unchanged
              email: '', // or remove if not used
            ),
          ),

        );


        _animationController.reverse();
        setState(() => _isEditing = false);
      } catch (e) {
        // ❌ Show error snackbar if something fails
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: $e')),
          );
        }
      }
    } else {
      _animationController.forward();
      setState(() => _isEditing = true);
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? '';

    return Scaffold(
    // backgroundColor: Colors.black,
      appBar:  AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              final userId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

              // 🔒 Run the block checker
              final isBlocked = await isUserBlocked(context, userId);

              // Optional: If blocked, don't reload profile
              if (isBlocked) return;

              // ✅ Reload profile
              context.read<ProfileBloc>().add(LoadUserProfile(userId));
              context.read<ProfileBloc>().add(StreamFollowerCount(userId));
              context.read<ProfileBloc>().add(StreamFollowingCount(userId));
            },

          ),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            context.read<ProfileBloc>().add(LoadUserProfile(widget.userId));
            context.read<ProfileBloc>().add(LoadUserPostCount(widget.userId));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Profile updated'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (state is ProfileLoaded) {
              final profile = state.profile;
              if (!_isEditing) {
                _nameController.text = profile.name;
                _bioController.text = profile.bio ?? '';
              }
              final statusText = () {
                if (profile.status == 'permanently_blocked') {
                  return '🚫 Permanently Blocked';
                } else if (profile.status == 'blocked') {
                  return '⛔ Blocked until: ${profile.blockedUntil?.toLocal().toString().split(".").first}';
                } else {
                  return '✅ Active';
                }
              }();

              final statusColor = () {
                if (profile.status == 'permanently_blocked') {
                  return Colors.red;
                } else if (profile.status == 'blocked') {
                  return Colors.orange;
                } else {
                  return Colors.green;
                }
              }();


              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ProfileHeader(
                          profile: profile,
                          email: email,
                          statusText: statusText,
                          statusColor: statusColor,
                        ),
                        ProfileStats(
                          postCount: state.postCount,
                          followerCount: state.followerCount,
                          followingCount: state.followingCount,
                        ),

                        // Add your content section here
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            onPressed: _toggleEditMode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.1),
                              padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: Colors.white.withOpacity(0.2)),
                              ),
                            ),
                            child: const Text(
                              'EDIT PROFILE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                //color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (profile.status == 'blocked')
                    Positioned(
                      top: 50,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'BLOCKED',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  EditProfilePanel(
                    animation: _editPanelAnimation,
                    nameController: _nameController,
                    bioController: _bioController,
                    onClose: () {
                      _animationController.reverse();
                      setState(() => _isEditing = false);
                    },
                    onSave: (imageFile) {
                      _toggleEditMode(imageFile);
                    },
                  ),
                ],
              );
            } else if (state is ProfileError) {
              return Center(
                child: Text(
                  "❌ ${state.message}",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          },
        ),
      ),
    );
  }
}