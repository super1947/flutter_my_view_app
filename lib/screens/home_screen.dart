import 'package:app/components/myreview_card.dart';
import 'package:app/data/database.dart';
import 'package:app/data/myreview.dart';
import 'package:app/style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
// import "package:collection/collection.dart";

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dao = GetIt.instance<MyReviewDao>();
  // final List<String> categoryItems = <String>[
  //     '가전/가구/인테리어',
  //     '음식/영화/도서',
  //     '의류/잡화/스포츠',
  //     '기타'
  //   ];

  renderReviewCard() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          child: StreamBuilder<List<MyReviewData>>(
            stream: dao.streamMyReviews(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    reverse: true,
                    itemBuilder: (_, index) {
                      final item = data[index];
                      return MyReviewCard(
                        imagepath: item.imagepath,
                        stars: item.stars,
                        category: item.category,
                        categoryDetail: item.categoryDetail,
                        title: item.title,
                        content: item.content,
                        createdAt: item.createdAt,
                      );
                    },
                    itemCount: data.length);
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
      backgroundColor: Colors.black,
      body: CustomScrollView(slivers: [
        renderSliverAppbar(),
        renderSliverTextBox('카테고리'),
        renderSliverCategoryCard(),
        renderSliverTextBox('목록'),
        renderReviewCard(),
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
            color: Color(0xff1f1e21),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: lightColor.withOpacity(0.3),
                offset: Offset(-3, -3),
                spreadRadius: 0,
                blurRadius: 9,
              ),
              BoxShadow(
                color: bgColor.withOpacity(0.3),
                offset: Offset(4, 4),
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
