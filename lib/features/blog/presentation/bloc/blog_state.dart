import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';

part 'blog_state.freezed.dart';

@freezed
class BlogState with _$BlogState {
  const factory BlogState.initial({
    @Default(0) int warningCount,
    @Default(false) bool isBlocked,
    @Default(false) bool showWarning,
  }) = BlogInitial;

  const factory BlogState.loading({
    @Default(0) int warningCount,
    @Default(false) bool isBlocked,
    @Default(false) bool showWarning,
  }) = BlogLoading;

  const factory BlogState.uploadSuccess({
    @Default(0) int warningCount,
    @Default(false) bool isBlocked,
    @Default(false) bool showWarning,
  }) = BlogUploadSuccess;

  const factory BlogState.displaySuccess({
    required List<Blog> blogs,
    @Default(0) int warningCount,
    @Default(false) bool isBlocked,
    @Default(false) bool showWarning,
  }) = BlogDisplaySuccess;

  const factory BlogState.failure({
    required String message,
    @Default(0) int warningCount,
    @Default(false) bool isBlocked,
    @Default(false) bool showWarning,
  }) = BlogFailure;
}
