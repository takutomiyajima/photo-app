import 'package:photoapp/model/postmodel.dart';

class Display {
  final String detail;
  final String imageUrl; 
  final String name;
  
  Display({
    required this.detail,
    required this.imageUrl,
    required this.name,
  });

  factory Display.fromPostFormState(PostFormState post) {
    return Display(
      detail: post.detail,
      imageUrl: post.image?.path ?? '',  // もしimageがFileなら、それをURLに変換
      name: post.name,
    );
  }
}
