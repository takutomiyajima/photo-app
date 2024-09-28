import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:photoapp/route.dart';
import 'package:photoapp/screen/setting.dart';
import 'firebase_options.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/screen/home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp( App());
}


