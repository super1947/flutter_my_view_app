import 'package:app/controller/app_controller.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/ranking_screen.dart';
import 'package:app/screens/write_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends GetView<AppController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (RouteName.values[controller.currentIndex.value]) {
          case RouteName.HomeScreen:
            return HomeScreen();
          case RouteName.RankingScreen:
            return RankingScreen();
          case RouteName.WriteSceen:
            return WriteScreen();
        }
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: controller.changePageIndex,
          currentIndex: controller.currentIndex.value,
          selectedItemColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.white,
          items: [
            _bottomNavigationBarItem(
                icon: Icons.home_outlined, actIcon: Icons.home, label: '홈'),
            _bottomNavigationBarItem(
                icon: Icons.star_border, actIcon: Icons.star, label: '랭킹'),
            _bottomNavigationBarItem(
                icon: Icons.add_box_outlined,
                actIcon: Icons.add_box,
                label: '글쓰기')
          ],
        ),
      ),
    );
  }
}

_bottomNavigationBarItem({IconData? icon, IconData? actIcon, String? label}) {
  return BottomNavigationBarItem(
      icon: Icon(icon), label: label, activeIcon: Icon(actIcon));
}
