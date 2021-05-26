import 'package:app/app.dart';
import 'package:app/binding/init_binding.dart';
import 'package:app/data/database.dart';
import 'package:app/data/myreview.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/ranking_screen.dart';
import 'package:app/screens/write_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

void main() {
  if (!GetIt.instance.isRegistered<MyReviewDao>()) {
    final db = Database();

    GetIt.instance.registerSingleton<MyReviewDao>(MyReviewDao(db));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'My_View',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialBinding: InitBinding(),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => App()),
          GetPage(name: '/home', page: () => HomeScreen()),
          GetPage(name: '/ranking', page: () => RankingScreen()),
          GetPage(name: '/write', page: () => WriteScreen()),
        ]);
  }
}
