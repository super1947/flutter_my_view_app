import 'dart:io';
import 'package:myview/controller/custom_rect_tween.dart';
import 'package:myview/data/myreview.dart';
import 'package:myview/screens/update_screen.dart';
import 'package:flutter/material.dart';
import 'package:myview/style.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:line_icons/line_icons.dart';

class MyReviewPopUpCard extends StatefulWidget {
  final int? id;
  final double? stars;
  final String? category;
  final String? categoryDetail;
  final String? title;
  final String? content;
  final DateTime? createdAt;
  final String? imagepath;

  MyReviewPopUpCard({
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
  _MyReviewPopUpCardState createState() => _MyReviewPopUpCardState();
}

class _MyReviewPopUpCardState extends State<MyReviewPopUpCard> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.id!,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xff1A1A1A),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    offset: Offset(4, 4),
                    spreadRadius: 0,
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: bgColor.withOpacity(0.25),
                    offset: Offset(-3, -3),
                    spreadRadius: 0,
                    blurRadius: 6,
                  )
                ]),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 23),
              child: SingleChildScrollView(
                child: Column(children: [
                  renderTopBar(),
                  SizedBox(
                    height: 10,
                  ),
                  widget.imagepath != ''
                      ? Container(
                          height: 200,
                          width: 300,
                          child: renderImageBox(),
                        )
                      : Container(),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        renderCategory(),
                        renderCategoryDetail(),
                        SizedBox(
                          height: 5,
                        ),
                        renderTitle(),
                        Divider(
                          height: 10,
                          color: Colors.grey[800],
                        ),
                        renderContent(),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  renderTopBar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            iconSize: 20.0,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(LineIcons.times),
          ),
          IconButton(
            iconSize: 20.0,
            onPressed: () {
              Get.defaultDialog(
                backgroundColor: Color(0xff202020),
                title: '',
                titleStyle: TextStyle(fontSize: 0),
                middleText: '게시물을 삭제할까요?',
                middleTextStyle: TextStyle(fontSize: 12),
                confirm: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(30, 30),
                    primary: Color(0xff303030),
                  ),
                  onPressed: () {
                    final dao = GetIt.instance<MyReviewDao>();
                    dao.deleteMyReviewById(widget.id!);
                    Get.back();
                    Get.back();
                  },
                  child: Text(
                    '확인',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                cancel: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(30, 30),
                    primary: Color(0xff303030),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    '취소',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
            icon: Icon(LineIcons.alternateTrashAlt),
          ),
          IconButton(
            iconSize: 20.0,
            onPressed: () {
              final page = UpdateScreen(
                  id: widget.id,
                  stars: widget.stars,
                  category: widget.category,
                  title: widget.title,
                  content: widget.content,
                  categoryDetail: widget.categoryDetail,
                  imagepath: widget.imagepath);
              Get.to(() => page);
            },
            icon: Icon(LineIcons.edit),
          ),
        ],
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.category!,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.grey,
            ),
          ),
          renderStars()
        ],
      ),
    );
  }

  renderCategoryDetail() {
    final ca = widget.createdAt!;
    final dateStr = '${ca.year}-${ca.month}-${ca.day} ';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.categoryDetail!,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        Text(
          dateStr,
          style: TextStyle(
            color: Colors.grey,
          ),
        )
      ],
    );
  }

  renderContent() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.content!,
              style: TextStyle(
                color: Colors.grey[200],
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  renderTitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.title!,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
