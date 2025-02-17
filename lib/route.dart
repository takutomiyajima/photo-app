import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photoapp/screen/home.dart';
import 'package:photoapp/component/bottom-bar.dart';
import 'package:photoapp/screen/login.dart';
import 'package:photoapp/screen/setting.dart';
import 'package:photoapp/screen/post.dart';
import 'package:photoapp/core/auth_provider.dart';
import 'package:photoapp/model/usermodel.dart';

// ナビゲーション用のキー
final rootNavigatorKey = GlobalKey<NavigatorState>();
final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final settingNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'setting');
final postNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'post');

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final authListenable = ref.watch(authListenableProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/login',
    refreshListenable: authListenable, 
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      final isLoggingIn = state.uri.toString() == '/login';

      if (!isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      return isLoggingIn ? '/home' : null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state, navigationShell) {
          return AppNavigationBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) {
                  return Consumer(
                    builder: (context, ref, child) {
                      final authUser = ref.watch(authProvider);
                      if (authUser == null) {
                        return Scaffold(
                          body: Center(child: Text('ユーザー情報が取得できません')),
                        );
                      }
                      return Home();
                    },
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: settingNavigatorKey,
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => Setting(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: postNavigatorKey,
            routes: [
              GoRoute(
                path: '/post',
                builder: (context, state) => PostScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
