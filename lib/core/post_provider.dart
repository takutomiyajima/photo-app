import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photoapp/core/auth_provider.dart';

class PostFormState {
  final String name;
  final String detail;
  final File? image;
  final String? uid;
  final bool isLoading;

  PostFormState({this.name = '', this.detail = '', this.image, this.uid, this.isLoading = false});

  PostFormState copyWith({String? name, String? detail, File? image, String? uid, bool? isLoading}) {
    return PostFormState(
      name: name ?? this.name,
      detail: detail ?? this.detail,
      image: image ?? this.image,
      uid: uid ?? this.uid,
      isLoading: isLoading ?? this.isLoading,
    );
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
