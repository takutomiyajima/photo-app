import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photoapp/core/info_notifier.dart';
import 'package:photoapp/model/usermodel.dart';

final userProvider = StateProvider((ref){
  return FirebaseAuth.instance.currentUser;
});

final infoProvider = StateProvider.autoDispose((ref) {
  return '';
});

final emailProvider = StateProvider.autoDispose((ref) {
  return '';
});

final passProvider = StateProvider.autoDispose((ref) {
  return '';
});

final nameProvider = StateProvider.autoDispose((ref) {
  return '';
});

final userinfoProvider = FutureProvider<Usermodel?>((ref) async {
  try {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null) return null;

    final snapshot = await FirebaseDatabase.instance.ref("users/${user.uid}/name").get();
    String? name;
    if (snapshot.exists) {
      name = snapshot.value as String?;
    }
    
    return Usermodel(
      user: user,
      uid: user.uid,
      name: name ?? user.displayName, 
    );
  } catch (e) {
    print("Error fetching user info: $e");
    return null; 
  }
});



final profileImageProvider = NotifierProvider<ProfileImageNotifier, String?>(() {
  return ProfileImageNotifier();
});