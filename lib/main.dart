import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:image_picker/image_picker.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyPage());
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}


class _MyPageState extends State<MyPage> {
  final ImagePicker _imagePicker = ImagePicker();
  String? imageurl;

  Future<void> pickImage()  async {
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (res != null) {
        await uploadImageToFirebase(File(res.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("$eの画像投稿に失敗しました"),
        )
      );
    }
  }

  Future<void> uploadImageToFirebase(File image) async{
  try {
    Reference reference = FirebaseStorage.instance
      .ref()
      .child("images/${DateTime.now().microsecondsSinceEpoch}.png");
    await reference.putFile(image);
    String downloadUrl = await reference.getDownloadURL();
    
    setState(() {
      imageurl = downloadUrl;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("画像を投稿できました"),
      )
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text("$eの画像投稿に失敗しました"),
      )
    );
  }
}


  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home:Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child:Padding(padding: const EdgeInsets.all(15),
          child: ListView(
            shrinkWrap: true,
            children: [
                Stack(children: [
                  Center(
                    child: CircleAvatar(
                    radius: 100,
                    child: imageurl == null ?
                    Icon(
                      Icons.person,
                      size: 200,
                      color: Colors.black26,
                    )
                    : SizedBox(
                      height: 200,
                      child: ClipOval(
                        child: Image.network(
                          imageurl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ),
                  ),
                  Positioned(
                    right: 130,
                    top: 7,
                    child: GestureDetector(
                    onTap: () {
                      pickImage(); // 非同期関数を await で呼び出す
                    },
                    child: 
                    const Icon(
                        Icons.camera_alt,
                        color:Colors.black,
                        size: 30,
                      ))
                  ),
                  
                ],),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "User name",
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  
                  )
                ),
              )
            ],
          ),))
      
    )
    );
  }
}
