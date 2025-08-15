import 'dart:io';
import 'dart:ui';
import 'package:ThinkBit/core/theme/app_pallete.dart';
import 'package:ThinkBit/features/profile/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePanel extends StatefulWidget {
  final Animation<double> animation;
  final TextEditingController nameController;
  final TextEditingController bioController;
  final String? currentImageUrl;
  final VoidCallback onClose;
  final Function(File?) onSave;

  const EditProfilePanel({
    super.key,
    required this.animation,
    required this.nameController,
    required this.bioController,
    this.currentImageUrl,
    required this.onClose,
    required this.onSave,
  });

  @override
  State<EditProfilePanel> createState() => _EditProfilePanelState();
}

class _EditProfilePanelState extends State<EditProfilePanel> {
  File? _selectedImage;
  bool _isCheckingImage = false;
  bool _imageExists = false;
  final supabase = Supabase.instance.client;
  @override
  void initState() {
    super.initState();
    _checkImageExistence();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }



  Future<void> _checkImageExistence() async {
    if (widget.currentImageUrl == null || widget.currentImageUrl!.isEmpty) {
      return;
    }

    setState(() => _isCheckingImage = true);

    try {
      // For Supabase storage, we should use the file path, not the full URL
      final response = await supabase.storage
          .from('avatars') // Your bucket name
          .download(widget.currentImageUrl!.split('/').last);

      setState(() => _imageExists = response != null);
    } catch (e) {
      debugPrint('Error checking image existence: $e');
      setState(() => _imageExists = false);
    } finally {
      setState(() => _isCheckingImage = false);
    }
  }

  Widget _buildAvatarImage() {
    if (_selectedImage != null) {
      return Image.file(_selectedImage!, fit: BoxFit.cover);
    }

    if (_isCheckingImage) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_imageExists && widget.currentImageUrl != null) {
      return Image.network(
        widget.currentImageUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
      );
    }

    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Image.asset(
      'assets/default_avatar.png',
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            (1.28 - widget.animation.value) * MediaQuery.of(context).size.height,
          ),
          child: child,
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.7),
              Colors.white.withOpacity(0.9),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.fromLTRB(25, 25, 25, 30),
        child: Column(
          children: [
            // Header without border
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        //color: Colors.white,
                        color: AppPallete.textColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 24),
                        onPressed: widget.onClose,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Profile Image with Edit Button
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        //color: Colors.white.withOpacity(0.3),
                        color: Colors.black.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: _buildAvatarImage(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Rest of your form fields remain the same...
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Name Field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        //color: Colors.white.withOpacity(0.1),
                        color: Colors.black.withOpacity(0.7),
                        border: Border.all(color: Colors.black.withOpacity(0.2)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: TextFormField(
                              controller: widget.nameController,
                              style: const TextStyle(
                                  color: Colors.white,
                                  //color: Colors.black,
                                  fontSize: 16),
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Bio Field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        //color: Colors.white.withOpacity(0.3),
                        color: Colors.black.withOpacity(0.7),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: TextFormField(
                              controller: widget.bioController,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                              minLines: 1,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: 'Bio',
                                labelStyle: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Save Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => widget.onSave(_selectedImage),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.withOpacity(0.2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                                color: Colors.green.withOpacity(0.5),
                                width: 1.5),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'SAVE CHANGES',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}