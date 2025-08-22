import 'package:game_notion/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp({required String email, required String password});
}
