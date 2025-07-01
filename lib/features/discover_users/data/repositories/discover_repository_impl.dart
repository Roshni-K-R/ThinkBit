import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../domain/repositories/discover_repository.dart';

class DiscoverRepositoryImpl implements DiscoverRepository {
  final supabase = Supabase.instance.client;

  @override
  Future<Either<Failure, List<UserProfile>>> getAllUsersExcept(String currentUserId) async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .neq('id', currentUserId);

      if (response is! List) {
        return Left(Failure('Invalid response format from server'));
      }

      final users = response.map((e) => UserProfile.fromMap(e)).toList();
      return Right(users);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to fetch users: ${e.toString()}'));
    }
  }
}