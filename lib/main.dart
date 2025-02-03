import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoapp/route.dart';
import 'package:photoapp/screen/home.dart';
import 'package:photoapp/screen/login.dart';
import 'package:photoapp/screen/usermodel.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(ProviderScope(child: MyApp()));
  } catch (e) {
    debugPrint("Firebaseの初期化に失敗しました: $e");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // ローディング中
        }
        if (snapshot.hasData) {
          final userModel = Usermodel.fromFirebase(snapshot.data!);
          return Home(userModel: userModel,); // ログイン済みならホームへ
        }
        return LoginPage(); // 未ログインならログインページへ
      },
    );
  }
}
