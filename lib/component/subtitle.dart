import 'package:flutter/material.dart';

class Subtitle extends StatelessWidget {
  final String title;
  const Subtitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 40, 
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.black45,
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.black45,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
