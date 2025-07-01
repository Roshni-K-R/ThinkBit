import 'package:blog_app/features/profile/domain/entities/user_profile.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';

abstract class DiscoverRepository {
  // discover_repository.dart
  Future<Either<Failure, List<UserProfile>>> getAllUsersExcept(String userId);
}
