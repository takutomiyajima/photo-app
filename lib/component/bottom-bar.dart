import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell, // ナビゲーションシェルをボディとして設定
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex, // 現在のインデックスを使用
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'home'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'setting'),
          NavigationDestination(icon: Icon(Icons.add_a_photo), label: 'post'),
        ],
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex, // 選択されたインデックスに移動
          );
        },
      ),
    );
  }
}






