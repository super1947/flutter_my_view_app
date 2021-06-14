import 'package:myview/components/myreview_card.dart';
import 'package:myview/controller/categoryview_controller.dart';
import 'package:myview/data/database.dart';
import 'package:myview/data/myreview.dart';
import 'package:myview/widget/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:collection/collection.dart';
import 'package:toggle_switch/toggle_switch.dart';

class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final controller = Get.put(CategoryViewController());
  final dao = GetIt.instance<MyReviewDao>();
  int isSelected = 0;
  late List<MyReviewData> myReviewsFiltered;
  String query = '';
  String category = '';

  searchReview(String query) async {
    final allMyReviews = await dao.getAllData();
    final myReviewsFiltered = allMyReviews.where((myReview) {
      final titleLower = myReview.title.toLowerCase();
      final categoryLower = myReview.category.toLowerCase();
      final categoryDetailLower = myReview.categoryDetail.toLowerCase();
      final contentLower = myReview.content.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          categoryLower.contains(searchLower) ||
          categoryDetailLower.contains(searchLower) ||
          contentLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.myReviewsFiltered = myReviewsFiltered;
    });
  }

  renderSearchArea() {
    return SearchWidget(
        text: query, onChanged: searchReview, hintText: '검색어를 입력하세요.');
  }

  renderRankingReviewCard(String category) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          child: StreamBuilder<List<MyReviewData>>(
            stream: category == '전체'
                ? dao.streamMyReviews()
                : dao.streamMyReviewsByCategory(category),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<MyReviewData> myReviews = snapshot.data!;
                isSelected == 0
                    ? myReviews = snapshot.data!
                    : myReviews.sort((a, b) => a.stars.compareTo(b.stars));
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    reverse: true,
                    itemBuilder: (_, index) {
                      var _myReview = myReviews[index];
                      this.query == ''
                          ? _myReview = myReviews[index]
                          : _myReview = myReviewsFiltered[index];
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
                    itemCount: this.query == ''
                        ? myReviews.length
                        : myReviewsFiltered.length);
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

  renderCategoryGrid() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                height: this.query == ''
                    ? MediaQuery.of(context).size.height * 0.25
                    : 0,
                child: StreamBuilder<List<MyReviewData>>(
                  stream: dao.streamMyReviews(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null && this.query == '') {
                      final myReviews = snapshot.data!;
                      final groupByCategory =
                          myReviews.groupListsBy((e) => e.category);
                      return Column(
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                _buildCategoryGridCard(0, '전체',
                                    '${myReviews.length}', Colors.pink, 15.0),
                                _buildCategoryGridCard(
                                    1,
                                    '가전/가구/\n인테리어',
                                    '${groupByCategory['가전/가구/인테리어'] == null ? 0 : groupByCategory['가전/가구/인테리어']?.length}',
                                    Colors.orange,
                                    13.0),
                                _buildCategoryGridCard(
                                    2,
                                    '의류/잡화',
                                    '${groupByCategory['의류/잡화'] == null ? 0 : groupByCategory['의류/잡화']?.length}',
                                    Colors.teal,
                                    14.0),
                                _buildCategoryGridCard(
                                    3,
                                    '음악/음반/\n아티스트',
                                    '${groupByCategory['음악/음반/아티스트'] == null ? 0 : groupByCategory['음악/음반/아티스트']?.length}',
                                    Colors.red,
                                    13.0),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                _buildCategoryGridCard(
                                    4,
                                    '영화/드라마/\n예능/콘텐츠',
                                    '${groupByCategory['영화/드라마/예능/콘텐츠'] == null ? 0 : groupByCategory['영화/드라마/예능/콘텐츠']?.length}',
                                    Colors.green,
                                    13.0),
                                _buildCategoryGridCard(
                                    5,
                                    '음식/음식점/\n프랜차이즈',
                                    '${groupByCategory['음식/음식점/프랜차이즈'] == null ? 0 : groupByCategory['음식/음식점/프랜차이즈']?.length}',
                                    Colors.lightBlue,
                                    13.0),
                                _buildCategoryGridCard(
                                    6,
                                    '기타',
                                    '${groupByCategory['기타'] == null ? 0 : groupByCategory['기타']?.length}',
                                    Colors.purple,
                                    15.0),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.data != null && this.query != '') {
                      return Container();
                    } else {
                      return Column(
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                _buildCategoryGridCard(
                                    0, '전체', '0', Colors.pink, 15.0),
                                _buildCategoryGridCard(1, '가전/가구/\n인테리어', '0',
                                    Colors.orange, 13.0),
                                _buildCategoryGridCard(
                                    2, '의류/잡화', '0', Colors.teal, 14.0),
                                _buildCategoryGridCard(
                                    3, '음악/음반/\n아티스트', '0', Colors.red, 13.0),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                _buildCategoryGridCard(4, '영화/드라마/\n예능/콘텐츠',
                                    '0', Colors.green, 13.0),
                                _buildCategoryGridCard(5, '음식/음식점/\n프랜차이즈', '0',
                                    Colors.lightBlue, 13.0),
                                _buildCategoryGridCard(
                                    6, '기타', '0', Colors.purple, 15.0),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
          childCount: 1),
    );
  }

  Expanded _buildCategoryGridCard(
      int index, String title, String count, MaterialColor color, double size) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            controller.changeCategoryViewIndex(index);
          });
        },
        child: Container(
          margin: const EdgeInsets.all(5.0),
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
                    fontWeight: FontWeight.w800),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
            ],
          ),
        ),
      ),
    );
  }

  renderToggleButton() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
            padding: this.query == ''
                ? EdgeInsets.symmetric(vertical: 10, horizontal: 16)
                : null,
            child: this.query == ''
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ToggleSwitch(
                        initialLabelIndex: isSelected,
                        minWidth: 80.0,
                        minHeight: 30.0,
                        activeBgColor: Color(0xffd9d9d9),
                        inactiveBgColor: Color(0xff1a1a1a),
                        labels: ['최신순', '별점순'],
                        onToggle: (index) {
                          setState(() {
                            isSelected = index;
                          });
                        },
                      ),
                    ],
                  )
                : Container()),
        childCount: 1,
      ),
    );
  }

  String? categoryStateController() {
    switch (controller.currentIndex.value) {
      case 0:
        return '전체';
      case 1:
        return '가전/가구/인테리어';
      case 2:
        return '의류/잡화';
      case 3:
        return '음악/음반/아티스트';
      case 4:
        return '영화/드라마/예능/콘텐츠';
      case 5:
        return '음식/음식점/프랜차이즈';
      case 6:
        return '기타';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff050505),
                    Color(0xff080808),
                  ],
                  stops: [0.0, 1],
                ),
              ),
            ),
            SafeArea(
              child: CustomScrollView(
                physics: ClampingScrollPhysics(),
                slivers: [
                  renderSearchArea(),
                  renderCategoryGrid(),
                  renderToggleButton(),
                  renderRankingReviewCard(categoryStateController()!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
