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
}