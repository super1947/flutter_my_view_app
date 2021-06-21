import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class ImageExpandCard extends StatelessWidget {
  // const ImageExpandCard({Key? key}) : super(key: key);

  late final String? imagepath;

  ImageExpandCard({
    required this.imagepath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(LineIcons.times),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: this.imagepath!,
          child: Image.file(
            File(this.imagepath!),
          ),
        ),
      ),
    );
  }
}
