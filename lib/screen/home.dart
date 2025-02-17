import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoapp/core/post_provider.dart';
import 'package:photoapp/core/info_provider.dart';
import 'package:photoapp/screen/flame.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userinfoProvider);

    return userInfo.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('ユーザーがログインしていません')),
          );
        }

        final postListAsync = ref.watch(postListProvider(user.uid));

        return Scaffold(
          appBar: AppBar(title: const Text('User Posts')),
          body: postListAsync.when(
            data: (posts) {
              return posts.isEmpty
                  ? const Center(child: Text('No posts found'))
                  : GridView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return Flame(post);
                      }, 
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,         
                        crossAxisSpacing: 1,       
                        mainAxisSpacing: 1,        
                        childAspectRatio: 1.0,     
                      ),
                    );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
