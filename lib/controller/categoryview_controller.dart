import 'package:get/get.dart';

enum CategoryName { All, Funiture, Clothes, Music, Movie, Food, Etc }

class CategoryViewController extends GetxController {
  static CategoryViewController get to => Get.find();
  RxInt currentIndex = 0.obs;

  void changeCategoryViewIndex(int index) {
    currentIndex(index);
  }
}
