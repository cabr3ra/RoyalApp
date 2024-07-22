import 'package:firebase_auth/firebase_auth.dart';

class UserAuth {
  final String id;
  final String email;

  UserAuth({
    required this.id,
    required this.email,
  });

  factory UserAuth.fromFirebase(User user) {
    return UserAuth(
      id: user.uid,
      email: user.email ?? '',
    );
  }
}
