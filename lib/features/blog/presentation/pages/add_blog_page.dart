import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ThinkBit/core/common/cubits/app_user/app_user_cubit.dart';

import 'package:ThinkBit/core/common/widgets/loader.dart';
import 'package:ThinkBit/core/theme/app_pallete.dart';
import 'package:ThinkBit/core/utils/pick_image.dart';
import 'package:ThinkBit/core/utils/show_snackbar.dart';
import 'package:ThinkBit/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:ThinkBit/features/blog/presentation/pages/blog_page.dart';
import 'package:ThinkBit/features/blog/presentation/widgets/blog_content_text_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/block_checker.dart';
import '../../../../init_dependencies.dart';
import '../../domain/usecases/check_abuse_usecase.dart';
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
  late FocusNode _quillFocusNode;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _quillFocusNode = FocusNode();
    _quillFocusNode.addListener(() {
      setState(() {}); // 🔄 Rebuild to change border color
    });
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
    _quillFocusNode.dispose();
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





  Future<void> handleAbusiveAttempt(String userId) async {
    final user = await supabase
        .from('profiles')
        .select('warning_count, blocked_until, total_warning_count')
        .eq('id', userId)
        .single();

    int warnings = user['warning_count'] ?? 0;
    int totalWarnings = user['total_warning_count'] ?? 0;

    // 🟥 Permanent block after 10 total warnings
    if (totalWarnings + 1 >= 10) {
      await supabase.from('profiles').update({
        'status': 'permanently_blocked',
        'blocked_until': null,
        'warning_count': 0,
        'total_warning_count': totalWarnings + 1,
      }).eq('id', userId);

      showSnackbar(context, "🚫 You have been permanently blocked due to repeated abuse.");
      return;
    }

    // ⛔ Temporary block after 3 warnings
    if (warnings >= 2) {
      final blockUntil = DateTime.now().toUtc().add(const Duration(minutes:  1)); // 3 days
      await supabase.from('profiles').update({
        'blocked_until': blockUntil.toIso8601String(),
        'status': 'blocked',
        'warning_count': 0, // reset current count
        'total_warning_count': totalWarnings + 1, // increment total
      }).eq('id', userId);

      showSnackbar(context, "🚫 You are blocked for 3 days due to repeated abuse.");
    } else {
      await supabase.from('profiles').update({
        'warning_count': warnings + 1,
        'total_warning_count': totalWarnings + 1,
      }).eq('id', userId);

      showSnackbar(context, "⚠️ Warning ${warnings + 1}/3: Abusive content detected.");
    }
  }




  void onAddPressed() async {
    final userId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    final title = _titleController.text.trim();
    final contentPlain = _quillController.document.toPlainText().trim();


    // 🔒 Check: Is user blocked?
    if (await isUserBlocked(context, userId)) {
      return;
    }

    // ✅ Step 1: Run form validation first
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    // ✅ Step 2: Check if all required fields are present
    if (selectedTopics.isEmpty || image == null) {
      showSnackbar(context, 'Please select an image and at least one topic.');
      return;
    }

    // ✅ Step 3: Now it's safe to call abuse detection
    final abuseCheckUseCase = serviceLocator<CheckAbuseUseCase>();
    final cleanTitle = normalizeObfuscation(title);
    final cleanContent = normalizeObfuscation(contentPlain);


    final isTitleAbusive = await abuseCheckUseCase(cleanTitle);
    final isContentAbusive = await abuseCheckUseCase(cleanContent);


    print("🧠 Title to check: $cleanTitle");
    print("🧠 Content to check: $cleanContent");


    if (isTitleAbusive || isContentAbusive) {
      await handleAbusiveAttempt(userId);
      return;
    }

    // ✅ Step 4: Submit blog
    final posterId = userId;
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


  String normalizeObfuscation(String text) {
    return text
        .replaceAllMapped(RegExp(r'[\$5]'), (_) => 's')
        .replaceAllMapped(RegExp(r'[1!|]'), (_) => 'i')
        .replaceAllMapped(RegExp(r'[@]'), (_) => 'a')
        .replaceAllMapped(RegExp(r'[0]'), (_) => 'o')
        .replaceAllMapped(RegExp(r'[\+]'), (_) => 't')
        .replaceAllMapped(RegExp(r'[\(\[]'), (_) => 'c');
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
                      const SizedBox(height: 10),
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

                      // Container(
                      //   //height: 300,
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.grey),
                      //     borderRadius: BorderRadius.circular(5),
                      //   ),
                      //   child: QuillToolbar.simple(
                      //     configurations: QuillSimpleToolbarConfigurations(
                      //       controller: _quillController,
                      //     ),
                      //   ),
                      // ),

                      const SizedBox(height: 10),
                      FormField<String>(
                        validator: (_) {
                          if (_quillController.document.toPlainText().trim().isEmpty) {
                            return 'Content is missing';
                          }
                          return null;
                        },
                        builder: (state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  if (_quillController.document.isEmpty() && !_quillFocusNode.hasFocus)
                                    const Positioned(
                                      top: 27,
                                      left: 27,
                                      child: Text(
                                        'Enter blog content',
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: state.hasError
                                            ? Colors.redAccent
                                            : (_quillFocusNode.hasFocus
                                            ? AppPallete.gradient2
                                            : AppPallete.borderColor),
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: QuillEditor(
                                      configurations: QuillEditorConfigurations(
                                        controller: _quillController,
                                        scrollable: false,
                                        padding: const EdgeInsets.all(27),
                                        expands: false,
                                        autoFocus: false,
                                        sharedConfigurations: const QuillSharedConfigurations(
                                          locale: Locale('en'),
                                        ),
                                      ),
                                      focusNode: _quillFocusNode,
                                      scrollController: ScrollController(),
                                    ),
                                  ),
                                ],
                              ),
                              if (state.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                                  child: Text(
                                    state.errorText ?? '',
                                    style: const TextStyle(color: AppPallete.gradient3, fontSize: 13),
                                  ),
                                ),
                            ],
                          );
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