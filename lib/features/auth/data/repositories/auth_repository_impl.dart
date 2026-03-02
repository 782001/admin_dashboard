import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient supabaseClient;

  AuthRepositoryImpl({required this.supabaseClient});

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user != null) {
      return UserEntity(id: user.id, email: user.email ?? '');
    }
    return null;
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
