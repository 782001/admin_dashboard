import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<void> signIn({required String email, required String password});
  Future<void> signOut();
}
