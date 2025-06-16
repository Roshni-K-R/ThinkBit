// blog_bloc.dart
import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/check_content_safty.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final BlogRepository _blogRepository;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
    required BlogRepository blogRepository,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        _blogRepository = blogRepository,
        super(const BlogState.initial()) {
    on<BlogUploadEvent>(_onBlogUpload);
    on<BlogGetAllEvent>(_fetchAllBlogs);
    on<CheckContentSafety>(_onContentSafetyCheck);
  }

  Future<void> _onContentSafetyCheck(
      CheckContentSafety event,
      Emitter<BlogState> emit,
      ) async {
    final result = ContentSafetyCheck(state.warningCount).execute(event.content);

    if (!result.isSafe && result.warningCount >= 3) {
      await _blogRepository.recordWarning(event.userId);
      emit(state.copyWith(isBlocked: true));
    } else if (!result.isSafe) {
      emit(state.copyWith(
        warningCount: result.warningCount,
        showWarning: true,
      ));
    }
  }

  Future<void> _onBlogUpload(
      BlogUploadEvent event,
      Emitter<BlogState> emit,
      ) async {
    emit(BlogState.loading(
      warningCount: state.warningCount,
      isBlocked: state.isBlocked,
      showWarning: state.showWarning,
    ));

    final res = await _uploadBlog.call(UploadBlogParams(
      posterId: event.posterId,
      title: event.title,
      content: event.content,
      image: event.image,
      topics: event.topics,
    ));

    res.fold(
          (l) => emit(BlogState.failure(
        message: l.message,
        warningCount: state.warningCount,
        isBlocked: state.isBlocked,
        showWarning: state.showWarning,
      )),
          (r) => emit(BlogState.uploadSuccess(
        warningCount: state.warningCount,
        isBlocked: state.isBlocked,
        showWarning: state.showWarning,
      )),
    );
  }

  Future<void> _fetchAllBlogs(
      BlogGetAllEvent event,
      Emitter<BlogState> emit,
      ) async {
    emit(BlogState.loading(
      warningCount: state.warningCount,
      isBlocked: state.isBlocked,
      showWarning: state.showWarning,
    ));

    final res = await _getAllBlogs.call(NoParams());

    res.fold(
          (l) => emit(BlogState.failure(
        message: l.message,
        warningCount: state.warningCount,
        isBlocked: state.isBlocked,
        showWarning: state.showWarning,
      )),
          (r) => emit(BlogState.displaySuccess(
        blogs: r,
        warningCount: state.warningCount,
        isBlocked: state.isBlocked,
        showWarning: state.showWarning,
      )),
    );
  }
}
