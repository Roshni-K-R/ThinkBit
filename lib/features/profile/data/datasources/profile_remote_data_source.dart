import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile_model.dart';

class ProfileRemoteDataSource {
  final supabase = Supabase.instance.client;

  Stream<UserProfileModel> getProfile(String userId) {
    return supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((event) => UserProfileModel.fromMap(event.first));
  }

  Future<void> updateProfile(UserProfileModel profile) {
    return supabase.from('profiles').update(profile.toMap()).eq('id', profile.id);
  }
}
