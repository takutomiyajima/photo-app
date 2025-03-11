import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photoapp/core/auth_provider.dart';
import 'package:photoapp/core/info_provider.dart';
import 'package:photoapp/model/usermodel.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アカウント登録'),
      ),
      body: LoginPageDetail(),
    );
  }
}

class LoginPageDetail extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(emailProvider);
    final name = ref.watch(nameProvider);
    final password = ref.watch(passProvider);
    final info = ref.watch(infoProvider);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'アカウントを登録する',
              style: TextStyle(fontSize: 15),
            ),
            const Divider(),
            TextFormField(
              decoration: InputDecoration(labelText: 'メールアドレスを入力'),
              onChanged: (value) => ref.read(emailProvider.notifier).state = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'ニックネームを入力'),
              onChanged: (value) => ref.read(nameProvider.notifier).state = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'パスワードを入力'),
              obscureText: true,
              onChanged: (value) => ref.read(passProvider.notifier).state = value,
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Text(info),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final auth = FirebaseAuth.instance;
                  final result = await auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  final String uid = result.user!.uid;
                  final refDb = FirebaseDatabase.instance.ref("users/$uid");
                  await refDb.set({
                    'name': name,
                    'email': email,
                    'timestamp': ServerValue.timestamp,
                  });
                  ref.read(infoProvider.notifier).state = "ログインボタンを押してログインしよう！";
                } catch (e) {
                  ref.read(infoProvider.notifier).state =
                      "登録に失敗しました：${e.toString()}";
                }
              },
              child: Text('登録する'),
            ),
            OutlinedButton(
              child: Text("ログイン"),
              onPressed: () async {
                try {
                  await ref.read(authProvider.notifier).signIn(email, password);
                  final user = ref.read(authProvider); 
                  if (user != null) {
                    print("ログイン成功: ${user.uid}");//デバッグ用
                  }
                } catch (e) {
                  print("ログインに失敗しました: $e");//デバッグ用
                }
              },
            )
          ],
        ),
      ),
    );
  }
}