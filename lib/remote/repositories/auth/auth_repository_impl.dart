import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_notion/models/user_model.dart';
import 'package:game_notion/remote/repositories/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;

  AuthRepositoryImpl({required FirebaseAuth auth}) : _auth = auth;

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user!.toUserModel();
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user!.toUserModel();
  }
}
