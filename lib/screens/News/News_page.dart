import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/constants.dart';
import 'package:flutter/material.dart';
import 'components/appBar.dart';
import 'components/news_card.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: bgSecondary,
        appBar: appBar(context),
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: constraints.maxWidth,
                decoration: const BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('news_alerts')
                        .orderBy('news_time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {

                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            height: constraints.maxHeight * 0.05,
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      }
                      final userData = snapshot.data?.docs;
                      if (userData!.isEmpty) {
                        return const Center(
                          child: Text('No Data'),
                        );
                      }
                      return ListView.builder(
                          itemCount: userData.length,
                          itemBuilder: (context, index) {
                            return NewsCard(
                              constraints: constraints,
                              newsTitle: userData[index]['news_title'],
                              newsBody: userData[index]['news_body'],
                              newsDate: userData[index]['news_time'].toDate(),
                              url: userData[index]['url'],
                            );
                          });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
