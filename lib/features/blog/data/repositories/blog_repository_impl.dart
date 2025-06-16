import 'dart:io';

import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final ConnectionChecker connectionChecker;
  final BlogLocalDataSource blogLocalDataSource;
  final SupabaseClient _supabase;

  BlogRepositoryImpl(
      this.blogRemoteDataSource,
      this.connectionChecker,
      this.blogLocalDataSource,
      this._supabase,
      );


  @override
  Future<Either<Failure, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet connection.'));
      }

      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        updatedAt: DateTime.now(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
          image: image, blog: blogModel);

      blogModel = blogModel.copyWith(imageUrl: imageUrl);
      return right(await blogRemoteDataSource.uploadBlog(blogModel));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }


  @override
  Future<void> recordWarning(String userId) async {
    final userResponse = await _supabase
        .from('users')
        .select('offensiveWarnings')
        .eq('id', userId)
        .single();

    if (userResponse == null || userResponse['offensiveWarnings'] == null) {
      throw ServerException('User not found or invalid field.');
    }

    final currentWarnings = userResponse['offensiveWarnings'] as int;

    final updateResponse = await _supabase
        .from('users')
        .update({'offensiveWarnings': currentWarnings + 1})
        .eq('id', userId);

    if (updateResponse.error != null) {
      throw ServerException(updateResponse.error!.message);
    }
  }

}
