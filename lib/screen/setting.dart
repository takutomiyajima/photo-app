import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/component/subtitle.dart';
import 'package:photoapp/core/auth_provider.dart';
import 'package:photoapp/core/info_provider.dart';
import 'package:photoapp/core/post_provider.dart';
import 'package:photoapp/screen/flame.dart';

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
    final userAsync = ref.watch(userinfoProvider); 
    final profileImageUrl = ref.watch(profileImageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 25),
              const Subtitle("profile"),
              const SizedBox(height: 30),
              Container(
                width: width,
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    // プロフィール画像
                    Container(
                      width: width * 0.5,
                      child: profileImageUrl != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(profileImageUrl),
                            )
                          : const CircleAvatar(
                              radius: 50,
                              child: Icon(Icons.person, size: 50),
                            ),
                    ),
                    // ユーザー情報
                    Container(
                      width: width * 0.4,
                      child: userAsync.when(
                        data: (userInfo) {
                          if (userInfo != null) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("名前: ${userInfo.name ?? "未設定"}"),
                                Text("UID: ${userInfo.uid}"),
                              ],
                            );
                          } else {
                            return const Text("ユーザー情報がありません");
                          }
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) => Text("エラー: $error"),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _pickAndUploadImage(context, ref),
                child: const Text("プロフィール画像を変更"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).signOut();
                },
                child: const Text("ログアウト"),
              ),
              const SizedBox(height: 25),
              const Subtitle("my post"),
              userAsync.when(
                data: (userInfo) {
                  if (userInfo == null) {
                    return const Text("ユーザー情報がありません");
                  }
                  final postListAsync = ref.watch(postListProvider(userInfo.uid));
                  return postListAsync.when(
                    data: (posts) {
                      return posts.isEmpty
                          ? const Center(child: Text('No posts found'))
                          : Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: posts.length,
                                itemBuilder: (context, index) {
                                  final post = posts[index];
                                  return Flame(post);
                                },
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 1,
                                  mainAxisSpacing: 2,
                                  childAspectRatio: 1.0,
                                ),
                              ),
                            );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) {
                      print("Post loading error: $error");
                      print("Stack trace: $stack");
                      return Center(child: Text('Post loading error: $error'));
                    }
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('User loading error: $error')), // ユーザー情報のエラーメッセージ表示
              ),
            ],
          ),
        ),
      ),
    );
  }
}
