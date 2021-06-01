import 'dart:io';
import 'package:app/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MyReviewCard extends StatefulWidget {
  final double? stars;
  final String? category;
  final String? categoryDetail;
  final String? title;
  final String? content;
  final DateTime? createdAt;
  final String? imagepath;

  MyReviewCard({
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Color(0xff1f1e21),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: lightColor.withOpacity(0.3),
                offset: Offset(4, 4),
                spreadRadius: 0,
                blurRadius: 9,
              ),
              BoxShadow(
                color: bgColor.withOpacity(0.3),
                offset: Offset(-3, -3),
                spreadRadius: 0,
                blurRadius: 6,
              )
            ]),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            height: 80,
            width: 70,
            child: renderImageBox(),
          ),
          Container(
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
        ]),
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
        itemSize: 20.0,
        direction: Axis.horizontal,
      ),
    );
  }

  renderCategory() {
    return Container(
      width: 250,
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
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.content!,
            style: TextStyle(
              color: Colors.grey[200],
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
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
