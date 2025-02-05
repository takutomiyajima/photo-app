import 'package:firebase_auth/firebase_auth.dart';

class Usermodel {
  final User user;
  final String? name;
  final String uid;

  Usermodel({
    required this.user,
    required this.uid,
    this.name,
  });

  factory Usermodel.fromFirebase(User user) {
    return Usermodel(
      uid: user.uid,
      name: user.displayName,
      user: user,
    );
  }
}