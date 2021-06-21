import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:myview/controller/app_controller.dart';
import 'package:myview/data/database.dart';
import 'package:myview/data/myreview.dart';
import 'package:myview/style.dart';
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
  late final BannerAd banner;

  @override
  void initState() {
    super.initState();
    imagepath = '';

    banner = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-7507714493839382/8476630248",
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

  static final List<String> categoryItems = <String>[
    '가전/가구/인테리어',
    '의류/잡화',
    '음악/음반/아티스트',
    '영화/TV프로그램',
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
      } else {
        this.imagepath = '';
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
            hintText: '브랜드/상품명',
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
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 50, 16, 0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      this.imagepath == ''
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                renderImagePickerBox(LineIcons.camera, '사진 찍기',
                                    ImageSource.camera),
                                SizedBox(width: 30.0),
                                renderImagePickerBox(LineIcons.image, '이미지 선택',
                                    ImageSource.gallery),
                              ],
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.18,
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
              Container(
                height: 50.0,
                child: AdWidget(
                  ad: this.banner,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
