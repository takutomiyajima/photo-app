import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:photoapp/component/bottom-bar.dart';
import 'package:photoapp/model/usermodel.dart';
import 'package:photoapp/core/auth_provider.dart';

class Home extends ConsumerWidget {
  final Usermodel userModel;

  Home({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DatabaseReference userRef = FirebaseDatabase.instance.ref("users/${userModel.uid}");

    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ユーザー名: ${userModel.name ?? "未設定"}'),
              Text('UID: ${userModel.uid}'),
              Text('メールアドレス: ${userModel.user.email ?? "不明"}'), // 修正
              ElevatedButton(
                child: Text("Logout"),
                onPressed: () {
                  ref.read(authProvider.notifier).signOut(); // 修正
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
