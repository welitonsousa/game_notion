import 'package:game_notion/models/user_model.dart';
import 'package:game_notion/remote/repositories/auth/auth_repository.dart';
import 'package:game_notion/remote/services/auth/auth_service.dart';

class AuthServiceImpl implements AuthService {
  final AuthRepository authRepository;

  AuthServiceImpl({required this.authRepository});

  @override
  Future<UserModel> signIn({required String email, required String password}) {
    return authRepository.signIn(email: email, password: password);
  }

  @override
  Future<UserModel> signUp({required String email, required String password}) {
    return authRepository.signUp(email: email, password: password);
  }
}
