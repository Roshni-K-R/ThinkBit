// getAll_users_except_current_usecase.dart
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../repositories/discover_repository.dart';

// getAll_users_except_current_usecase.dart
class GetAllUsersExceptCurrentUsecase {
  final DiscoverRepository repository;

  GetAllUsersExceptCurrentUsecase(this.repository);

  Future<Either<Failure, List<UserProfile>>> call(String userId) async {
    // Should return List<UserProfile>
    return repository.getAllUsersExcept(userId);
  }
}