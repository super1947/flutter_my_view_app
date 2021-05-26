import 'package:get/get.dart';

enum RouteName { HomeScreen, RankingScreen, WriteSceen }

class AppController extends GetxService {
  static AppController get to => Get.find();
  RxInt currentIndex = 0.obs;

  void changePageIndex(int index) {
    currentIndex(index);
  }
}
