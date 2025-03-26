import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoapp/component/subtitle.dart';
import 'package:photoapp/core/auth_provider.dart';
import 'package:photoapp/core/post_provider.dart';
import 'package:photoapp/core/info_provider.dart';
import 'package:photoapp/screen/flame.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    print("authState: $authState");

    if (authState == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final userInfo = ref.watch(userinfoProvider);

    return userInfo.when(
      data: (user) {
        if (user == null || user.uid == null) {
          return const Scaffold(
            body: Center(child: Text('ユーザーがログインしていません')),
          );
        }

        final postListAsync = ref.watch(otherListProvider(user.uid));

        return Scaffold(
          appBar: AppBar(title: const Text("Home")),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 25),
                const Subtitle("other posts"),
                const SizedBox(height: 15),
                postListAsync.when(
                  data: (posts) {
                    if (posts.isEmpty) {
                      return const Center(child: Text('No posts found'));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          childAspectRatio: 1.0,
                        ),
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('エラーが発生しました: $error')),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('エラーが発生しました: $error')),
      ),
    );
  }
}
