import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/constants.dart';
import 'package:fintech/network/model/firebase_model.dart';
import 'package:fintech/screens/News/expand_news.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/appBar.dart';
import 'components/news_card.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Map> _newsList = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

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
                        return const CircularProgressIndicator();
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
                            return newsCard(
                              constraints: constraints,
                              newsTitle: userData[index]['news_title'],
                              newsBody: userData[index]['news_body'],
                              newsDate: userData[index]['news_time'].toDate(),
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
