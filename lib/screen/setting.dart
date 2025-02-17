import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/component/subtitle.dart';
import 'package:photoapp/core/info_provider.dart';

class Setting extends ConsumerWidget {
  const Setting({super.key});

  Future<void> _pickAndUploadImage(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await ref.read(profileImageProvider.notifier).uploadProfileImage(imageFile);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final user = ref.watch(userinfoProvider);
    final profileImageUrl = ref.watch(profileImageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 25,),
            Subtitle("profile"),
            SizedBox(height: 30,),
            Container(
              width: width,
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                      Container(
                        width: width * 0.5,
                        child: 
                          profileImageUrl != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(profileImageUrl),
                            )
                          : CircleAvatar(
                              radius: 50,
                              child: Icon(Icons.person, size: 50,),
                            ),
                      ),
                      Container(
                        width: width * 0.4,
                        child: user.when(
                          data: (userInfo) => userInfo != null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("名前: ${userInfo.name ?? "未設定"}"),
                                  Text("UID: ${userInfo.uid}"),
                                ],
                              )
                              : Text("ユーザー情報がありません"),
                          loading: () => CircularProgressIndicator(),
                          error: (error, stack) => Text("エラー: $error"),
                        ),
                      ), 
                ],
              )
            ),
            ElevatedButton(
              onPressed: () => _pickAndUploadImage(context, ref),
              child: Text("画像を変更"),
            ),
            

          ],
        )

      ),
    );
  }
}