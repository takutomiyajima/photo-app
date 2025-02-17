import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photoapp/core/auth_provider.dart';
import 'package:photoapp/model/displaymodel.dart';
import 'package:photoapp/model/postmodel.dart';

class PostFormNotifier extends StateNotifier<PostFormState> {
  final Ref ref;
  PostFormNotifier(this.ref) : super(PostFormState()) {
    _initializeUser();
  }

  final ImagePicker _picker = ImagePicker();

  void _initializeUser() {
    final uid = ref.read(authDetailProvider).currentUser?.uid;
    state = state.copyWith(uid: uid);
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      state = state.copyWith(image: File(pickedFile.path));
    }
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateDetail(String detail) {
    state = state.copyWith(detail: detail);
  }

  Future<String?> uploadImage() async {
    if (state.image == null) return null;

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await imageRef.putFile(state.image!);
      return await imageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}

final postFormProvider = StateNotifierProvider<PostFormNotifier, PostFormState>((ref) {
  return PostFormNotifier(ref);
});

final postListProvider = StreamProvider.family<List<Display>, String>((ref, uid) {
  return FirebaseDatabase.instance
      .ref('posts')  // postsのパスにアクセス
      .orderByChild('id')  // 'id'フィールドで絞り込み
      .equalTo(uid)  // uidと一致するデータを取得
      .onValue  // リアルタイムでデータを受け取る
      .map((event) {
        final snapshot = event.snapshot;
        if (snapshot.value == null) {
          return [];  // 値がnullの場合、空のリストを返す
        }

        final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        final posts = <Display>[];

        data.forEach((key, value) {
          final post = PostFormState.fromFirebase(Map<String, dynamic>.from(value));
          posts.add(Display.fromPostFormState(post));
        });

        return posts;
      });
});


