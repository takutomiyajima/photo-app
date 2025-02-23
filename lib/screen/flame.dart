import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoapp/model/displaymodel.dart';

class Flame extends ConsumerWidget {
  final Display post;

  const Flame(this.post, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 300, 
      height: 300, 
      child: AspectRatio(
        aspectRatio: 1, 
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  post.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Image load error: $error');
                    return const Icon(Icons.error, color: Colors.red);
                  },
                ),
              ),
              Text(post.name),
            ],
          ),
        ),
      ),
    );
  }
}
