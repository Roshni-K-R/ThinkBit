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
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../init_dependencies.dart';
import '../bloc/blog_state.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/extensions.dart'; // for Document.fromJson



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
  late QuillController _quillController;
  final _formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;
  Timer? _debounceTimer;
  List<String> abusiveWords = [];

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    _loadDraft();
    loadAbusiveWords().then((words) {

      setState(() {
        abusiveWords = words;
      });
    });
  }

  bool containsAbusiveLanguage(String input) {
    final words = input
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '') // remove punctuation
        .split(RegExp(r'\s+')) // split on space
        .where((word) => word.isNotEmpty)   // Skip empty
        .toList();


    print('ABUSIVE CHECK: input=$input');
    print('WORDS: $words');
    print('ABUSIVE LIST: $abusiveWords');

    for (final word in words) {
      if (abusiveWords.contains(word.trim())) {
        print("🚨 Found abusive word: $word");
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
        final title = draft['title'] ?? '';
        final deltaJson = draft['content'] as List<dynamic>;
        final topics = List<String>.from(draft['topics'] ?? []);
        final imagePath = draft['imagePath'];

        setState(() {
          _titleController.text = title;
          selectedTopics = topics;
          if (imagePath != null) {
            image = File(imagePath);
          }

          /// IMPORTANT: Re-initialize the QuillController from saved content
          _quillController = QuillController(
            document: Document.fromJson(deltaJson),
            selection: const TextSelection.collapsed(offset: 0),
          );
        });
      }
    }
  }


  Future<void> _saveDraft() async {
    final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('blog_draft_${user.id}', jsonEncode({
      'title': _titleController.text,
      //'content': _contentController.text,
      'content': _quillController.document.toDelta().toJson(), // ✅ no jsonEncode here
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
    _quillController.dispose();
    //_contentController.dispose();
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

  Future<bool> isUserBlocked(String userId) async {
    try {
      final res = await Supabase.instance.client
          .from('profiles')
          .select('blocked_until, status')
          .eq('id', userId)
          .single();

      final blockedUntil = res['blocked_until'];
      final status = res['status'];

      if (blockedUntil != null) {
        final now = DateTime.now().toUtc();
        final unblockTime = DateTime.parse(blockedUntil);

        // 👇 Check if block expired
        if (now.isAfter(unblockTime)) {
          // ✅ Unblock the user
          await Supabase.instance.client
              .from('profiles')
              .update({
            'status': 'active',
            'blocked_until': null,
          })
              .eq('id', userId);

          print("✅ User $userId unblocked automatically.");
          return false;
        }

        // ⛔ Still blocked
        return true;
      }

      // ✅ No block set
      return false;
    } catch (e) {
      print('❌ Error checking block status: $e');
      return false;
    }
  }


  Future<void> handleAbusiveAttempt(String userId) async {
    final user = await supabase.from('profiles').select('warning_count, blocked_until').eq('id', userId).single();
    int warnings = user['warning_count'] ?? 0;


    if (warnings >= 2) {
      // Block the user for 3 days
      final blockUntil = DateTime.now().toUtc().add(const Duration(minutes: 1));
      await supabase.from('profiles').update({
        'blocked_until': blockUntil.toIso8601String(),
        'warning_count': 0, // reset warning count
        'status': 'blocked',
      }).eq('id', userId);

      showSnackbar(context, "🚫 You are blocked for 3 days due to repeated abuse.");
    } else {
      // Increment warning count
      await supabase.from('profiles').update({
        'warning_count': warnings + 1,
      }).eq('id', userId);

      showSnackbar(context, " ⚠️ Warning ${warnings + 1}/3: Abusive content detected.");
    }
  }
  // Future<void> handleAbusiveAttempt(String userId) async {
  //   final now = DateTime.now().toUtc();
  //   final cutoff = now.subtract(const Duration(hours: 48));
  //
  //   // 1. Count how many attempts in last 48h
  //   final response = await supabase
  //       .from('abuse_logs')
  //       .select()
  //       .eq('user_id', userId)
  //       .gte('timestamp', cutoff.toIso8601String());
  //
  //   final data = response;
  //
  //   final recentWarnings = (data as List).length;
  //
  //   // 2. Log this attempt
  //   await supabase.from('abuse_logs').insert({
  //   'user_id': userId,
  //   'timestamp': now.toIso8601String(),
  //   });
  //
  //   if (recentWarnings >= 2) {
  //   final blockUntil = now.add(const Duration(minutes: 1));
  //   await supabase.from('profiles').update({
  //   'blocked_until': blockUntil.toIso8601String(),
  //   'status': 'blocked',
  //   }).eq('id', userId);
  //
  //   showSnackbar(context, '🚫 You have been blocked for 3 days.');
  //   } else {
  //   showSnackbar(context, '⚠️ Warning remove abusive content from the blog ${recentWarnings + 1}/3 in 48h.');
  //   }
  // }



  void onAddPressed() async {
    final userId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    final title = _titleController.text.trim();
    final content=_contentController.text.trim();
    final contentPlain = _quillController.document.toPlainText();

    // 🔒 First check: Is user blocked?
    if (await isUserBlocked(userId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are temporarily blocked from posting. Try again later.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 🛑 Check for abusive content
    if (containsAbusiveLanguage(title) || containsAbusiveLanguage(contentPlain)) {
      print("⚠️ Abusive detected in content: $contentPlain");
      await handleAbusiveAttempt(userId); // 👈 add this line
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
          content: contentPlain,
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
            _quillController.document.toPlainText().trim().isNotEmpty ||
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
                      // const SizedBox(height: 10),
                      // BlogContentTextfield(
                      //   controller: _contentController,
                      //   hintText: "Blog Content",
                      //   onChanged: (_) => _saveDraftDebounced(),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Content is missing';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      const SizedBox(height: 10),

                      Container(
                        //height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: QuillToolbar.simple(
                          configurations: QuillSimpleToolbarConfigurations(
                            controller: _quillController,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: QuillEditor(
                          configurations: QuillEditorConfigurations(
                            controller: _quillController,
                            scrollable: true,
                            autoFocus: false,
                            //readOnly: false,
                            padding: const EdgeInsets.all(10),
                            expands: false,
                            sharedConfigurations: const QuillSharedConfigurations(
                              locale: Locale('en'),
                            ),
                          ),
                          focusNode: FocusNode(),
                          scrollController: ScrollController(),
                        ),

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