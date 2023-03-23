import 'package:flutter/material.dart';

import '../../News/News_page.dart';
import 'HomeCard.dart';

SizedBox buildNewsList(BoxConstraints constraint, bool newsLoading, List newsData, Function() getUserDetails, Function() getNewsData) {
  return SizedBox(
    width: constraint.maxWidth,
    height: constraint.maxHeight * 0.18,
    child: Padding(
      padding: const EdgeInsets.only(
          left: 20, right: 20, top: 8, bottom: 8),
      child: newsLoading
          ? const Center(
          child: CircularProgressIndicator())
          : ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: newsData.length,
          padding:
          const EdgeInsets.only(right: 5),
          itemBuilder: (context, index) {
            Map news = newsData[index];
            return InkWell(
              onTap: () async {
                var push = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                        const NewsPage()));
                if (push == true) {
                  await getUserDetails();
                  await getNewsData();
                }
              },
              child: HomeCard(
                constraint: constraint,
                title: news['news_title'],
              ),
            );
          }),
    ),
  );
}