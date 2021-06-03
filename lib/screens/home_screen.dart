import 'package:app/components/myreview_card.dart';
import 'package:app/data/database.dart';
import 'package:app/data/myreview.dart';
import 'package:app/style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
// import "package:collection/collection.dart";

class HomeScreen extends StatelessWidget {
  final dao = GetIt.instance<MyReviewDao>();

  renderReviewCard() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          child: StreamBuilder<List<MyReviewData>>(
            stream: dao.streamMyReviews(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final myReviews = snapshot.data!;
                print(myReviews);
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    reverse: true,
                    itemBuilder: (_, index) {
                      final _myReview = myReviews[index];
                      return MyReviewCard(
                        id: _myReview.id,
                        imagepath: _myReview.imagepath,
                        stars: _myReview.stars,
                        category: _myReview.category,
                        categoryDetail: _myReview.categoryDetail,
                        title: _myReview.title,
                        content: _myReview.content,
                        createdAt: _myReview.createdAt,
                      );
                    },
                    itemCount: myReviews.length);
              } else {
                return Container();
              }
            },
          ),
        ),
        childCount: 1,
      ),
    );
  }

  renderSliverAppbar() {
    return SliverAppBar(
      backgroundColor: Colors.black,
      floating: true,
      title: Text('마이뷰'),
    );
  }

  renderSliverTextBox(String text) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        childCount: 1,
      ),
    );
  }

  renderSliverCategoryCard() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => StreamBuilder<List<MyReviewData>>(
            stream: dao.streamMyReviews(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // final data = snapshot.data!;
                // final groupByCategory = data.groupListsBy((e) => e.category);
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildCategoryCard(FontAwesomeIcons.couch,
                            Color(0xff0092cc), '가전/가구/\n\   인테리어'),
                        SizedBox(width: 20),
                        _buildCategoryCard(FontAwesomeIcons.guitar,
                            Color(0xff05F4B7), '음악/음반/\n   아티스트'),
                        SizedBox(width: 20),
                        _buildCategoryCard(FontAwesomeIcons.video,
                            Color(0xff5626C4), '영화/드라마/\n 예능/콘텐츠'),
                        SizedBox(width: 20),
                        _buildCategoryCard(FontAwesomeIcons.hamburger,
                            Color(0xffFB8122), '음식/음식점/\n   프랜차이즈'),
                        SizedBox(width: 20),
                        _buildCategoryCard(FontAwesomeIcons.solidCommentDots,
                            Color(0xffFA255E), '기타'),
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            }),
        childCount: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundFadedColor,
      body: Stack(children: [
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
          slivers: [
            renderSliverAppbar(),
            renderSliverTextBox('카테고리'),
            renderSliverCategoryCard(),
            renderSliverTextBox('목록'),
            renderReviewCard(),
          ],
        )),
      ]),
    );
  }
}

Widget _buildCategoryCard(icon, color, title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        height: 100.0,
        width: 100.0,
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400]!.withOpacity(0.2),
                offset: Offset(-2, -2),
                spreadRadius: 0,
                blurRadius: 9,
              ),
              BoxShadow(
                color: bgColor.withOpacity(0.2),
                offset: Offset(2, 2),
                spreadRadius: 0,
                blurRadius: 6,
              )
            ]),
        child: Container(
          child: Icon(
            icon,
            size: 37,
            color: color,
          ),
        ),
      ),
      Container(
        height: 50,
        child: Text(
          title,
          style: subtitleStyle,
        ),
      ),
    ],
  );
}
