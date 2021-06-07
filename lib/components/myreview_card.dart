import 'dart:io';
import 'package:app/components/myreview_popup_card.dart';
import 'package:app/controller/custom_rect_tween.dart';
import 'package:app/controller/hero_dialog_route.dart';
import 'package:app/data/database.dart';
import 'package:app/data/myreview.dart';
import 'package:app/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class MyReviewCard extends StatefulWidget {
  final int? id;
  final double? stars;
  final String? category;
  final String? categoryDetail;
  final String? title;
  final String? content;
  final DateTime? createdAt;
  final String? imagepath;

  MyReviewCard({
    this.id,
    required this.stars,
    required this.category,
    this.categoryDetail,
    required this.title,
    required this.content,
    required this.createdAt,
    this.imagepath,
  });

  @override
  _MyReviewCardState createState() => _MyReviewCardState();
}

class _MyReviewCardState extends State<MyReviewCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(HeroDialogRoute(
            builder: (context) => Center(
                  child: MyReviewPopUpCard(
                    id: widget.id,
                    category: widget.category,
                    stars: widget.stars,
                    categoryDetail: widget.categoryDetail,
                    title: widget.title,
                    content: widget.content,
                    createdAt: widget.createdAt,
                    imagepath: widget.imagepath,
                  ),
                )));
      },
      child: Hero(
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        tag: widget.id!,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 13.0),
              decoration: BoxDecoration(
                  color: Color(0xff1A1A1A),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500]!.withOpacity(0.18),
                      offset: Offset(2, 2),
                      spreadRadius: 0,
                      blurRadius: 3,
                    ),
                    BoxShadow(
                      color: bgColor.withOpacity(0.2),
                      offset: Offset(-2, -2),
                      spreadRadius: 0,
                      blurRadius: 3,
                    )
                  ]),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 70,
                        width: 80,
                        child: renderImageBox(),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            renderCategory(),
                            renderCategoryDetail(),
                            renderTitle(),
                            SizedBox(
                              height: 5,
                            ),
                            renderContent(),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  renderImageBox() {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: widget.imagepath != ''
            ? Image.file(
                File(widget.imagepath!),
                fit: BoxFit.fill,
              )
            : Image.asset(
                'assets/images/default-image.jpg',
                fit: BoxFit.fill,
              ),
      ),
    );
  }

  renderStars() {
    return Container(
      child: RatingBarIndicator(
        rating: widget.stars!,
        itemBuilder: (context, index) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        itemCount: 5,
        itemSize: 15.0,
        direction: Axis.horizontal,
      ),
    );
  }

  renderCategory() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.category!,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          renderStars()
        ],
      ),
    );
  }

  renderCategoryDetail() {
    return Row(
      children: [
        Text(
          widget.categoryDetail!,
          style: TextStyle(color: Colors.grey, fontSize: 11.0),
        ),
      ],
    );
  }

  renderContent() {
    final ca = widget.createdAt!;
    final dateStr = '${ca.year}-${ca.month}-${ca.day}';

    return Container(
      child: Text(
        widget.content!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.grey[200],
        ),
      ),
    );
  }

  renderTitle() {
    return Row(
      children: [
        Text(
          widget.title!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
