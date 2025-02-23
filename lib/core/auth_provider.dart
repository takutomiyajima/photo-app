import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart'; 

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

final authDetailProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

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

class AuthListenable extends ChangeNotifier {
  AuthListenable(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

final authListenableProvider = ChangeNotifierProvider<AuthListenable>((ref) {
  return AuthListenable(ref); // ChangeNotifierProviderRef から渡される
});
