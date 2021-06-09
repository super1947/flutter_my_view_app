import 'dart:io';
import 'package:app/data/database.dart';
import 'package:app/data/myreview.dart';
import 'package:app/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:moor/moor.dart' hide Column;

class UpdateScreen extends StatefulWidget {
  int? id;
  double? stars;
  String? category;
  String? title;
  String? content;
  String? categoryDetail;
  String? imagepath;

  UpdateScreen({
    required this.id,
    required this.stars,
    required this.category,
    required this.title,
    required this.content,
    required this.categoryDetail,
    required this.imagepath,
  });

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  int? id;
  double? stars;
  String? category;
  String? title;
  String? content;
  String? categoryDetail;
  String? imagepath;

  @override
  void initState() {
    super.initState();
    imagepath = widget.imagepath;
    id = widget.id;
  }

  static final List<String> categoryItems = <String>[
    '가전/가구/인테리어',
    '의류/잡화',
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
        print(widget.imagepath);
      } else {
        this.imagepath = '';
        print(widget.imagepath);
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
          margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
              color: Color(0xff1a1a1a),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  offset: Offset(3, 2),
                  spreadRadius: 0,
                  blurRadius: 5,
                ),
                BoxShadow(
                  color: bgColor.withOpacity(0.2),
                  offset: Offset(-3, -3),
                  spreadRadius: 0,
                  blurRadius: 5,
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
          value: widget.category,
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
            widget.category = val;
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          initialValue: widget.categoryDetail,
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
            widget.categoryDetail = val;
          },
          onChanged: (newValue) {
            widget.categoryDetail = newValue;
          },
        ),
        TextFormField(
          initialValue: widget.title,
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
            widget.title = val;
          },
          onChanged: (newValue) {
            widget.title = newValue;
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
          initialRating: widget.stars!,
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
            widget.stars = val;
          },
        ),
        SizedBox(
          height: 30,
        ),
        TextFormField(
          initialValue: widget.content,
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
          onChanged: (newValue) {
            widget.content = newValue;
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

                if (widget.content != null &&
                    widget.title != null &&
                    widget.category != null &&
                    widget.stars != null) {
                  final dao = GetIt.instance<MyReviewDao>();
                  var myReviewCompanion = MyReviewCompanion(
                    id: Value(widget.id!),
                    stars: Value(widget.stars!),
                    title: Value(widget.title!),
                    content: Value(widget.content!),
                    category: Value(widget.category!),
                    categoryDetail: Value(widget.categoryDetail!),
                    imagepath: Value(this.imagepath!),
                  );
                  await dao.updateMyReview(myReviewCompanion);
                  print(myReviewCompanion);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
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
        backgroundColor: Color(0xff050505),
        appBar: AppBar(
          title: Text('마이뷰'),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                16.0, 16.0, 16.0, MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  this.imagepath == ''
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            renderImagePickerBox(
                                LineIcons.camera, '사진 찍기', ImageSource.camera),
                            SizedBox(width: 30.0),
                            renderImagePickerBox(
                                LineIcons.image, '이미지 선택', ImageSource.gallery),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.14,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(this.imagepath!),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            renderImagePickerBox(LineIcons.camera, '사진 다시 찍기',
                                ImageSource.camera),
                            SizedBox(width: 20.0),
                            renderImagePickerBox(LineIcons.syncIcon, '이미지 변경',
                                ImageSource.gallery),
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
