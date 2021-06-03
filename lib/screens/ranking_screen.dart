import 'package:app/screens/home_screen.dart';
import 'package:app/style.dart';
import 'package:flutter/material.dart';

class RankingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeScreen homeScreen = HomeScreen();
    return Scaffold(
      backgroundColor: AppColors.backgroundFadedColor,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.backgroundFadedColor,
                  AppColors.backgroundColor,
                ],
                stops: [0.0, 1],
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: ClampingScrollPhysics(),
              slivers: [
                homeScreen.renderSliverAppbar(),
                renderCategoryGrid(),
                homeScreen.renderReviewCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget renderCategoryGrid() {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        _buildCategoryGridCard(
                            '가전/가구/인테리어', '1', Colors.orange, 15.0),
                        _buildCategoryGridCard(
                            '음악/음반/아티스트', '1', Colors.red, 15.0),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        _buildCategoryGridCard(
                            '영화/드라마/예능/콘텐츠', '1', Colors.green, 12.0),
                        _buildCategoryGridCard(
                            '음식/음식점/프랜차이즈', '1', Colors.lightBlue, 12.0),
                        _buildCategoryGridCard('기타', '1', Colors.purple, 12.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        childCount: 1),
  );
}

Expanded _buildCategoryGridCard(
    String title, String count, MaterialColor color, double size) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: size,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
