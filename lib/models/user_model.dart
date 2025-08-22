import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String name;
  final String email;
  final String? photoUrl;
  final String? uid;

  UserModel({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.uid,
  });
}

extension UserModelExtension on User {
  UserModel toUserModel() {
    return UserModel(
      name: displayName ?? '',
      email: email ?? '',
      photoUrl: photoURL,
      uid: uid,
    );
  }
}
