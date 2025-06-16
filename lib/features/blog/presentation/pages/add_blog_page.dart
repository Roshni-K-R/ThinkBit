import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_content_text_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../init_dependencies.dart';
import '../bloc/blog_state.dart';

class AddBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const AddBlogPage(),
  );
  const AddBlogPage({super.key});

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;
  Timer? _debounceTimer;
  List<String> abusiveWords = [];

  @override
  void initState() {
    super.initState();
    _loadDraft();
    loadAbusiveWords().then((words) {
      setState(() {
        abusiveWords = words;
      });
    });
  }

  bool containsAbusiveLanguage(String input) {
    final words = input.toLowerCase().split(RegExp(r'\s+|[.,!?]'));
    for (final word in words) {
      if (abusiveWords.contains(word)) {
        return true;
      }
    }
    return false;
  }

  Future<void> _loadDraft() async {
    final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    final prefs = await SharedPreferences.getInstance();
    final draftJson = prefs.getString('blog_draft_${user.id}');

    if (draftJson != null) {
      final draft = jsonDecode(draftJson);
      if (draft['userId'] == user.id) {
        setState(() {
          _titleController.text = draft['title'] ?? '';
          _contentController.text = draft['content'] ?? '';
          selectedTopics = List<String>.from(draft['topics'] ?? []);
          if (draft['imagePath'] != null) {
            image = File(draft['imagePath']);
          }
        });
      }
    }
  }

  Future<void> _saveDraft() async {
    final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('blog_draft_${user.id}', jsonEncode({
      'title': _titleController.text,
      'content': _contentController.text,
      'topics': selectedTopics,
      'imagePath': image?.path,
      'userId': user.id,
    }));
  }

  Future<void> _clearDraft() async {
    final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('blog_draft_${user.id}');
  }

  void _saveDraftDebounced() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) _saveDraft();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
      _saveDraftDebounced();
    }
  }

  void onAddPressed() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (containsAbusiveLanguage(title) || containsAbusiveLanguage(content)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your blog contains abusive language. Please remove it.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      context.read<BlogBloc>().add(
        BlogUploadEvent(
          posterId: posterId,
          title: title,
          content: content,
          image: image!,
          topics: selectedTopics,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_titleController.text.isNotEmpty ||
            _contentController.text.isNotEmpty ||
            image != null) {
          await _saveDraft();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Draft saved automatically')),
            );
          }
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create new Blog'),
        ),
        body: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogUploadSuccess) {
              // Clear draft only after successful upload
              _clearDraft();
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                    (route) => false,
              );
            }else if (state is BlogFailure) {
              showSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Loader();
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      image != null
                          ? GestureDetector(
                        onTap: selectImage,
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                          : GestureDetector(
                        onTap: selectImage,
                        child: DottedBorder(
                          color: AppPallete.borderColor,
                          dashPattern: const [10, 4],
                          radius: const Radius.circular(10),
                          borderType: BorderType.RRect,
                          strokeCap: StrokeCap.round,
                          child: const SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 50,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Select your image",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            'Technology',
                            'Business',
                            'Programming',
                            'Entertainment',
                          ]
                              .map(
                                (e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedTopics.contains(e)) {
                                      selectedTopics.remove(e);
                                    } else {
                                      selectedTopics.add(e);
                                    }
                                  });
                                  _saveDraftDebounced();
                                },
                                child: Chip(
                                  label: Text(e),
                                  color: selectedTopics.contains(e)
                                      ? const WidgetStatePropertyAll(
                                      AppPallete.gradient1)
                                      : null,
                                  side: selectedTopics.contains(e)
                                      ? null
                                      : const BorderSide(
                                    color: AppPallete.borderColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      BlogContentTextfield(
                        controller: _titleController,
                        hintText: "Title",
                        onChanged: (_) => _saveDraftDebounced(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Title is missing';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      BlogContentTextfield(
                        controller: _contentController,
                        hintText: "Blog Content",
                        onChanged: (_) => _saveDraftDebounced(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Content is missing';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16),
                        child: TextButton(
                          onPressed: onAddPressed,
                          style: TextButton.styleFrom(
                            backgroundColor: AppPallete.gradient1,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Post',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}