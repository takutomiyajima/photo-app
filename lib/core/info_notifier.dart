import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileImageNotifier extends Notifier<String?> {
  final _database = FirebaseDatabase.instance.ref();
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  @override
  String? build() {
    _loadProfileImage();
    return null;
  }

  Future<void> _loadProfileImage() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _database.child("users/${user.uid}/profileImage").get();
    if (snapshot.exists) {
      state = snapshot.value as String?;
    }
  }

  Future<void> uploadProfileImage(File imageFile) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final storageRef = _storage.ref().child("profile_images/${user.uid}.jpg");
    await storageRef.putFile(imageFile);
    final imageUrl = await storageRef.getDownloadURL();

    await _database.child("users/${user.uid}/profileImage").set(imageUrl);
    state = imageUrl;
  }
}