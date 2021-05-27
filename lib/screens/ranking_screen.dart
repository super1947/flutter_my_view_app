import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class RankingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: IconButton(onPressed: () {}, icon: Icon(LineIcons.addressBook)),
      ),
    );
  }
}
