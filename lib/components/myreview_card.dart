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
      onLongPress: () {
        print('clicked');
        print(widget.id);
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
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400]!.withOpacity(0.2),
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
    if (widget.imagepath != '')
      return Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            File(widget.imagepath!),
            fit: BoxFit.fill,
          ),
        ),
      );
    else
      return Container();
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
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  renderContent() {
    final ca = widget.createdAt!;
    final dateStr = '${ca.year}-${ca.month}-${ca.day}';

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.content!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[200],
              ),
            ),
          ),
          Text(
            dateStr,
            style: TextStyle(
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  renderTitle() {
    return Row(
      children: [
        Text(
          widget.title!,
          maxLines: 1,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
