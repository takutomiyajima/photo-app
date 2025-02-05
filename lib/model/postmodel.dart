import 'dart:io';

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