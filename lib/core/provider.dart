import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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