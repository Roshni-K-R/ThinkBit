import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    if (_isEditing) {
      context.read<ProfileBloc>().add(
        UpdateUserProfileEvent(
          UserProfile(
            id: widget.userId,
            name: _nameController.text,
            bio: _bioController.text,
            email: '',
          ),
        ),
      );
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() => _isEditing = !_isEditing);
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? '';

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
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

              final statusText = profile.status == 'blocked'
                  ? '⛔ Blocked until: ${profile.blockedUntil?.toLocal().toString().split(".").first}'
                  : '✅ Active';
              final statusColor = profile.status == 'blocked' ? Colors.red : Colors.green;

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
                        const ProfileStats(),
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
                                color: Colors.white,
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
                    onSave: _toggleEditMode,
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