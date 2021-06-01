import 'dart:io';

import 'package:app/controller/app_controller.dart';
import 'package:app/data/database.dart';
import 'package:app/data/myreview.dart';
import 'package:app/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:moor/moor.dart' hide Column;

class WriteScreen extends StatefulWidget {
  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  double? stars;
  String? category;
  String? title;
  String? content;
  String? categoryDetail;
  String? imagepath;
  String? categoryResult;

  @override
  void initState() {
    super.initState();
    imagepath = '';
  }

  static final List<String> categoryItems = <String>[
    '가전/가구/인테리어',
    '음악/음반/아티스트',
    '영화/드라마/예능/콘텐츠',
    '음식/음식점/프랜차이즈',
    '기타'
  ];

  String value = categoryItems.first;

  Future getImage(ImageSource imageSource) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: imageSource);

    setState(() {
      if (pickedFile != null) {
        this.imagepath = File(pickedFile.path).path;
        print(imagepath);
      } else {
        this.imagepath = '';
        print(imagepath);
      }
    });
  }

  renderImagePickerBox(IconData icon, String text, ImageSource imagesource) {
    return GestureDetector(
      onTap: () {
        getImage(imagesource);
      },
      child: Container(
          height: 100.0,
          width: 100.0,
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
              color: Color(0xff1f1e21),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  offset: Offset(3, 3),
                  spreadRadius: 0,
                  blurRadius: 9,
                ),
                BoxShadow(
                  color: bgColor.withOpacity(0.3),
                  offset: Offset(-6, -6),
                  spreadRadius: 0,
                  blurRadius: 6,
                )
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                icon,
                size: 40.0,
              ),
              Text(text)
            ],
          )),
    );
  }

  renderTextFields() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          dropdownColor: Color(0xff1f1e21),
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              labelText: '카테고리'),
          value: value,
          items: categoryItems
              .map((categoryItems) => DropdownMenuItem<String>(
                    child: Text(
                      categoryItems,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    value: categoryItems,
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              this.value = value!;
            });
          },
          onSaved: (val) {
            this.category = val;
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          maxLength: 30,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.deepPurple,
                width: 2.0,
              ),
            ),
            hintText: '세부 카테고리',
          ),
          onSaved: (val) {
            this.categoryDetail = val;
          },
        ),
        TextFormField(
          maxLength: 30,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.deepPurple,
                width: 2.0,
              ),
            ),
            hintText: '이름',
          ),
          onSaved: (val) {
            this.title = val;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return '필수 입력 항목입니다.';
            } else {
              return null;
            }
          },
        ),
        SizedBox(
          height: 10,
        ),
        RatingBar.builder(
          initialRating: 0,
          minRating: 0.5,
          direction: Axis.horizontal,
          allowHalfRating: true,
          glow: false,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (val) {
            this.stars = val;
          },
        ),
        SizedBox(
          height: 30,
        ),
        TextFormField(
          maxLines: null,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.deepPurple,
                width: 2.0,
              ),
            ),
            isDense: true,
            hintText: '내용',
          ),
          onSaved: (val) {
            this.content = val;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return '필수 입력 항목입니다.';
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  renderElevationButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();

                if (this.content != null &&
                    this.title != null &&
                    this.category != null &&
                    this.stars != null) {
                  final dao = GetIt.instance<MyReviewDao>();
                  var myReviewCompanion = MyReviewCompanion(
                    stars: Value(this.stars!),
                    title: Value(this.title!),
                    content: Value(this.content!),
                    category: Value(this.category!),
                    categoryDetail: Value(this.categoryDetail!),
                    imagepath: Value(this.imagepath!),
                  );
                  await dao.insertMyReview(
                    myReviewCompanion,
                  );
                  print(categoryDetail);
                  print(imagepath);
                  AppController.to.currentIndex.value = 0;
                }
              }
            },
            child: Text(
              '저장하기',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('마이뷰'),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      renderImagePickerBox(
                          LineIcons.camera, '사진 찍기', ImageSource.camera),
                      SizedBox(width: 30.0),
                      renderImagePickerBox(
                          LineIcons.image, '이미지 선택', ImageSource.gallery),
                    ],
                  ),
                  renderTextFields(),
                  SizedBox(
                    height: 10,
                  ),
                  renderElevationButton(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
