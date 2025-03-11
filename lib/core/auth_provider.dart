import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null) {
    _authStateListener();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _authStateListener() {
    // Auth state listener must be initialized after the object is created
    _auth.authStateChanges().listen((user) {
      state = user;
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception("ログインに失敗しました: $e");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class AuthListenable extends ChangeNotifier {
  AuthListenable(Ref ref) {
    // authProvider の状態変更を監視
    ref.listen(authProvider, (_, __) {
      // 状態が更新されるたびに通知
      notifyListeners();
    });
  }
}

final authListenableProvider = ChangeNotifierProvider<AuthListenable>((ref) {
  return AuthListenable(ref); // ChangeNotifierProviderRef から渡される
});
