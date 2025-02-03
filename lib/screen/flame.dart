import 'package:flutter/material.dart';

class Flame extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        width: 150,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1)
        ),
        child: Column(
          children: [
            Expanded(child: Text("data"))
          ],
        ),

    );
  }
}