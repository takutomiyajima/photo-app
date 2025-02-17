import 'package:photoapp/model/postmodel.dart';

class Display {
  final String detail;
  final String imageUrl; // 画像URL
  final String name;
  
  Display({
    required this.detail,
    required this.imageUrl,
    required this.name,
  });

  // PostFormStateからDisplayに変換
  factory Display.fromPostFormState(PostFormState post) {
    return Display(
      detail: post.detail,
      imageUrl: post.image?.path ?? '',  // もしimageがFileなら、それをURLに変換
      name: post.name,
    );
  }
}
