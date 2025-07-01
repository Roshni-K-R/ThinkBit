import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:blog_app/features/profile/domain/entities/user_profile.dart';
import 'package:blog_app/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final supabase = Supabase.instance.client;

  @override
  Stream<UserProfile> getProfile(String userId) {
    return supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((rows) => UserProfile.fromMap(rows.first));
  }


  @override
  Future<void> updateProfile(UserProfile profile) async {
    await supabase
        .from('profiles')
        .update(profile.toMap())
        .eq('id', profile.id);
  }

  @override
  Future<int> getPostCount(String userId) async {
    final res = await supabase
        .from('blogs')
        .select()
        .eq('poster_id', userId);

    return res.length;
  }



}
