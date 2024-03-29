import 'package:myview/components/myreview_card.dart';
import 'package:myview/controller/app_controller.dart';
import 'package:myview/controller/categoryview_controller.dart';
import 'package:myview/data/database.dart';
import 'package:myview/data/myreview.dart';
import 'package:myview/style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dao = GetIt.instance<MyReviewDao>();
  final controller = Get.put(CategoryViewController());

  late final BannerAd banner;

  @override
  void initState() {
    super.initState();
    banner = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-7507714493839382/3815669810",
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          print(error);
        },
      ),
      request: AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    banner.dispose();
  }

  renderHomeReviewCard() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          child: StreamBuilder<List<MyReviewData>>(
            stream: dao.streamMyReviews(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final myReviews = snapshot.data!;
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    reverse: true,
                    itemBuilder: (_, index) {
                      final myReview = myReviews[index];
                      return MyReviewCard(
                        id: myReview.id,
                        imagepath: myReview.imagepath,
                        stars: myReview.stars,
                        category: myReview.category,
                        categoryDetail: myReview.categoryDetail,
                        title: myReview.title,
                        content: myReview.content,
                        createdAt: myReview.createdAt,
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
      backgroundColor: Color(0xff050505),
      floating: true,
      title: Text('마이뷰'),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  renderSliverTextBox(String text, double toppadding) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          padding: EdgeInsets.fromLTRB(25, toppadding, 0, 5),
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
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildCategoryCard(1, FontAwesomeIcons.couch,
                            Color(0xff0092cc), '가전/가구/\n\ 인테리어'),
                        SizedBox(width: 20),
                        _buildCategoryCard(2, FontAwesomeIcons.tshirt,
                            Color(0xff272AB0), '의류/잡화'),
                        SizedBox(width: 20),
                        _buildCategoryCard(3, FontAwesomeIcons.guitar,
                            Color(0xff05F4B7), '음악/음반/\n 아티스트'),
                        SizedBox(width: 20),
                        _buildCategoryCard(4, FontAwesomeIcons.video,
                            Color(0xff5626C4), '영화/\n TV프로그램'),
                        SizedBox(width: 20),
                        _buildCategoryCard(5, FontAwesomeIcons.hamburger,
                            Color(0xffFB8122), '음식/음식점/\n 프랜차이즈'),
                        SizedBox(width: 20),
                        _buildCategoryCard(6, FontAwesomeIcons.solidCommentDots,
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
      body: Stack(
        alignment: Alignment.bottomCenter,
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
              slivers: [
                renderSliverTextBox('카테고리', 30),
                renderSliverCategoryCard(),
                renderSliverTextBox('목록', 0),
                renderHomeReviewCard(),
              ],
            ),
          ),
          Container(
            height: 50.0,
            child: AdWidget(
              ad: this.banner,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCategoryCard(int index, IconData icon, Color color, String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          AppController.to.currentIndex.value = 1;
          CategoryViewController.to.currentIndex.value = index;
        },
        child: Container(
          height: 85.0,
          width: 85.0,
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
              color: Color(0xff1A1A1A),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400]!.withOpacity(0.2),
                  offset: Offset(-2, -2),
                  spreadRadius: 0,
                  blurRadius: 3,
                ),
                BoxShadow(
                  color: bgColor.withOpacity(0.2),
                  offset: Offset(2, 2),
                  spreadRadius: 0,
                  blurRadius: 2,
                )
              ]),
          child: Container(
            child: Icon(
              icon,
              size: 25,
              color: color,
            ),
          ),
        ),
      ),
      Container(
        height: 35,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: lightColor,
          ),
        ),
      ),
    ],
  );
}
