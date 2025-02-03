import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart'; 

// Firebaseの認証状態を管理するプロバイダー
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

// 認証状態を管理するStateNotifier
class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(FirebaseAuth.instance.currentUser) {
    _authStateListener();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _authStateListener() {
    _auth.authStateChanges().listen((user) {
      state = user;
    });
  }

  Future<void> signIn(String email, String password) async {
    await _auth.setPersistence(Persistence.LOCAL);
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// GoRouterのリフレッシュ用にChangeNotifierを作成
class AuthListenable extends ChangeNotifier {
  AuthListenable(WidgetRef ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

// AuthListenableを提供するプロバイダー
final authListenableProvider = Provider<AuthListenable>((ref) {
  return AuthListenable(ref as WidgetRef);
});
