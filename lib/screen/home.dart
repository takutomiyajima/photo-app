import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/screen/usermodel.dart';


class Home extends StatelessWidget {
  final Usermodel userModel;
  Home({required this.userModel});

  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${userModel.uid}");
    
    return MaterialApp(
      home:Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
          child: Column(
            children: [
                Text('ユーザー名: ${userModel.name ?? "未設定"}'),
                Text('UID: ${userModel.uid}'),
                Text('メールアドレス: ${userModel.user.email ?? "不明"}'),
              ],
            )
          ,),
        )
      );
  }
}