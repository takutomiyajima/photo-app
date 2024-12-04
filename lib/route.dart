import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photoapp/screen/home.dart';
import 'package:photoapp/component/bottom-bar.dart';
import 'package:photoapp/screen/login.dart';
import 'package:photoapp/screen/setting.dart';
import 'package:photoapp/screen/post.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final settingNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'setting');
final PostNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'post');

class App extends StatelessWidget{
  App({super.key});
  
final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: rootNavigatorKey,
      builder:(context, state, navigationShell) {
        return AppNavigationBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) {
                final user = state.extra as User; // extraからUserオブジェクトを取り出す
                return Home(user); // Homeに直接渡す
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: settingNavigatorKey,
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => LoginPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: PostNavigatorKey,
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
@override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: appRouter.routeInformationProvider,
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
    );
}
}