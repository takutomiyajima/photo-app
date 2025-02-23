import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photoapp/core/auth_provider.dart';
import 'package:photoapp/model/displaymodel.dart';
import 'package:photoapp/model/postmodel.dart';
import 'package:image/image.dart' as img;

Future<File?> resizeImage(File imageFile) async {
  try {
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      print('Error: Image decoding failed.');
      return null;
    }
    final resizedImage = img.copyResize(image, width: 600); // 幅600pxにリサイズ
    final resizedBytes = img.encodeJpg(resizedImage);
    final resizedFile = await imageFile.writeAsBytes(resizedBytes);
    return resizedFile;
  } catch (e) {
    print('Error resizing image: $e');
    return null;
  }
}

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
      print("選択された画像のパス: ${pickedFile.path}");
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
      // 画像をリサイズ
      final resizedImage = await resizeImage(state.image!);
      if (resizedImage == null) {
        print('Image resizing failed');
        return null;
      }

      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // アップロードとURL取得を同時に行う
      await imageRef.putFile(resizedImage);
      final downloadURL = await imageRef.getDownloadURL();

      return downloadURL;
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
      .ref('posts')  
      .orderByChild('id')  
      .equalTo(uid)  
      .onValue  
      .map((event) {
        final snapshot = event.snapshot;
        if (snapshot.value == null) {
          return [];  
        }

        final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        final posts = data.entries.map((entry) {
          final post = PostFormState.fromFirebase(Map<String, dynamic>.from(entry.value));
          return Display.fromPostFormState(post);
        }).toList();

        return posts;
      });
});

