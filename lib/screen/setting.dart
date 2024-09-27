import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('白いページ'),
      ),
      body: Container(
        color: Colors.white, // 背景色を白に設定
        child: Center(
          child: Text(
            'これは白いページです',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black, // テキストの色を黒に設定
            ),
          ),
        ),
      ),
    );
  }
}