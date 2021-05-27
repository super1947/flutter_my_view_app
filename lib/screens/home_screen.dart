import 'package:app/components/myreview_card.dart';
import 'package:app/data/database.dart';
import 'package:app/data/myreview.dart';
import 'package:app/style.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:line_icons/line_icons.dart';
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
                        _buildCategoryCard(LineIcons.couch, Colors.cyanAccent,
                            '가전/가구/\n\   인테리어'),
                        SizedBox(width: 20),
                        _buildCategoryCard(LineIcons.music,
                            Colors.deepOrangeAccent, '음악/음반/\n   아티스트'),
                        SizedBox(width: 20),
                        _buildCategoryCard(LineIcons.video,
                            Colors.lightGreenAccent, '영화/드라마/\n 예능/콘텐츠'),
                        SizedBox(width: 20),
                        _buildCategoryCard(LineIcons.hamburger,
                            Colors.deepPurpleAccent, '음식/음식점/\n   프랜차이즈'),
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
        margin: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
            color: Color(0xff1f1e21),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: lightColor.withOpacity(0.3),
                offset: Offset(-5, -5),
                spreadRadius: 0,
                blurRadius: 9,
              ),
              BoxShadow(
                color: bgColor.withOpacity(0.3),
                offset: Offset(6, 6),
                spreadRadius: 0,
                blurRadius: 6,
              )
            ]),
        child: Center(
          child: Icon(
            icon,
            size: 46,
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

// Container(
//                             width: 150,
//                             margin: EdgeInsets.only(right: 20),
//                             height: categoryHeight,
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: Color(0xff3e3e3e), width: 3.0),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(20.0))),
//                             child: Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text(
//                                     "가전/가구/인테리어",
//                                     style: TextStyle(
//                                         fontSize: 25,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Text(
//                                     '${groupByCategory['가전/가구/인테리어'] == null ? 0 : groupByCategory['가전/가구/인테리어']?.length} items',
//                                     style: TextStyle(
//                                         fontSize: 16, color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                             width: 150,
//                             margin: EdgeInsets.only(right: 20),
//                             height: categoryHeight,
//                             decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Color(0xfffbb040),
//                                     Color(0xfff9ed32)
//                                   ],
//                                   begin: Alignment.centerLeft,
//                                   end: Alignment.centerRight,
//                                 ),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(20.0))),
//                             child: Container(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(15.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     Text(
//                                       "음식/영화/도서",
//                                       style: TextStyle(
//                                           fontSize: 25,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     Text(
//                                       '${groupByCategory['음식/영화/도서'] == null ? 0 : groupByCategory['음식/영화/도서']?.length} items',
//                                       style: TextStyle(
//                                           fontSize: 16, color: Colors.white),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             width: 150,
//                             margin: EdgeInsets.only(right: 20),
//                             height: categoryHeight,
//                             decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Color(0xff2d388a),
//                                     Color(0xff00aeef)
//                                   ],
//                                   begin: Alignment.centerLeft,
//                                   end: Alignment.centerRight,
//                                 ),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(20.0))),
//                             child: Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text(
//                                     "의류/잡화/스포츠",
//                                     style: TextStyle(
//                                         fontSize: 25,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Text(
//                                     '${groupByCategory['의류/잡화/스포츠'] == null ? 0 : groupByCategory['의류/잡화/스포츠']?.length} items',
//                                     style: TextStyle(
//                                         fontSize: 16, color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                             width: 150,
//                             margin: EdgeInsets.only(right: 20),
//                             height: categoryHeight,
//                             decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Color(0xff7f00ff),
//                                     Color(0xffe100ff)
//                                   ],
//                                   begin: Alignment.centerLeft,
//                                   end: Alignment.centerRight,
//                                 ),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(20.0))),
//                             child: Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text(
//                                     "기타",
//                                     style: TextStyle(
//                                         fontSize: 25,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Text(
//                                     '${groupByCategory['기타'] == null ? 0 : groupByCategory['기타']?.length} items',
//                                     style: TextStyle(
//                                         fontSize: 16, color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),