import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'dart:io';

class PostScreen extends StatefulWidget{
  PostScreen();
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  FirebaseDatabase database = FirebaseDatabase.instance;

  @override

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await imageRef.putFile(image);
      return await imageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  void _submitData() async {
  if (_formKey.currentState!.validate()) {
    String name = _nameController.text;
    String detail = _detailController.text;

    if (_selectedImage == null) {
      print("画像を選択してください");
      return;
    }

    String? imageUrl = await _uploadImage(_selectedImage!);

    if (imageUrl == null) {
      print("画像のアップロードに失敗しました");
      return;
    }

    try {
      // Firestore にデータを保存
      await FirebaseFirestore.instance.collection('posts').add({
        'name': name,
        'detail': detail,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // フォームをリセット
      _nameController.clear();
      _detailController.clear();
      setState(() {
        _selectedImage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('投稿が完了しました'))
      );
    } catch (e) {
      print("データの保存に失敗しました: $e");
    }
  }
}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Text('post'),
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'タイトルを入力'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'タイトルを入力してください';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _detailController,
                    decoration: InputDecoration(labelText: 'キャプションを入力'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'キャプションを入力してください';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      height: 150,
                    )
                  : Text('画像が選択されていません'),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('画像を選択'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitData,
                    child: Text('送信'),
                  ),
                ],),)
            ],
          ),
        ),
      ),
    );
  }
}