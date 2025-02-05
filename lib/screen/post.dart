import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:photoapp/core/post_provider.dart';
import 'package:uuid/uuid.dart';
import '../firebase_options.dart';
import 'dart:io';

class PostScreen extends ConsumerWidget {

  PostScreen({Key? key}) : super(key: key);

  void checkLoginStatus() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print('ログイン中: ${user.email}');
  } else {
    print('ログインしていません');
  }
}

  Future<void> _submitData(WidgetRef ref, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final postState = ref.read(postFormProvider);
    if (postState.name.isEmpty || postState.detail.isEmpty) {
      print("タイトルとキャプションを入力してください");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('タイトルとキャプションを入力してください')),
      );
      return;
    }

    if (postState.image == null) {
      print("画像を選択してください");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('画像を選択してください')),
      );
      return;
    }

    String? imageUrl = await ref.read(postFormProvider.notifier).uploadImage();
    if (imageUrl == null) {
      print("画像のアップロードに失敗しました");
      return;
    }

    try {
      var uuid = Uuid();
      String newUuid = uuid.v4();
      final refDb = FirebaseDatabase.instance.ref("posts/$newUuid");
      await refDb.set({
        'name': postState.name,
        'detail': postState.detail,
        'imageUrl': imageUrl,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'id': user?.uid,
      });

      ref.read(postFormProvider.notifier).updateName('');
      ref.read(postFormProvider.notifier).updateDetail('');
      ref.read(postFormProvider.notifier).state = PostFormState();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('投稿が完了しました')),
      );
    } catch (e) {
      print("データの保存に失敗しました: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Text('post'),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'タイトルを入力'),
                      onChanged: (value) => ref.read(postFormProvider.notifier).updateName(value),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'キャプションを入力'),
                      onChanged: (value) => ref.read(postFormProvider.notifier).updateDetail(value),
                    ),
                    SizedBox(height: 20),
                    postState.image != null
                        ? Image.file(
                            postState.image!,
                            height: 150,
                          )
                        : Text('画像が選択されていません'),
                    ElevatedButton(
                      onPressed: () => ref.read(postFormProvider.notifier).pickImage(),
                      child: Text('画像を選択'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _submitData(ref, context),
                      child: Text('送信'),
                    ),
                    ElevatedButton(onPressed: checkLoginStatus, child: Text("data"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
