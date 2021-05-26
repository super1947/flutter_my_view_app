import 'package:app/components/myreview_card.dart';
import 'package:app/data/database.dart';
import 'package:app/data/myreview.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dao = GetIt.instance<MyReviewDao>();
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        StreamBuilder<List<MyReviewData>>(
          stream: dao.streamMyReviews(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return Expanded(
                child: ListView.builder(
                    reverse: true,
                    itemBuilder: (_, index) {
                      final item = data[index];
                      return MyReviewCard(
                        stars: item.stars,
                        category: item.category,
                        categoryDetail: item.categoryDetail,
                        title: item.title,
                        content: item.content,
                        createdAt: item.createdAt,
                      );
                    },
                    itemCount: data.length),
              );
            } else {
              return Container();
            }
          },
        ),
      ]),
    );
  }
}
