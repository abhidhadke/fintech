import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/constants.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'components/appBar.dart';
import 'components/news_card.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  final RefreshController _newsRefreshController = RefreshController();
  bool newsLoading = true;
  var newsData = [];

  @override
  void initState() {
    super.initState();
    getNewsData();
  }

  getNewsData() async {
    final news = await FirebaseFirestore.instance.collection('news_alerts').get();
    newsData = news.docs.map((e) => e.data()).toList();
    debugPrint('getting news Data');
    setState(() {
      newsLoading = false;
      _newsRefreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, true);
          return Future.value(false);
        },
        child: Scaffold(
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
                    child: SmartRefresher(
                      header: const WaterDropMaterialHeader(
                        backgroundColor: secondary,
                        color: bgSecondary,
                      ),
                      onRefresh: getNewsData,
                      enablePullDown: true,
                      enablePullUp: false,
                      controller: _newsRefreshController,
                      child: ListView.builder(
                          itemCount: newsData.length,
                          itemBuilder: (context, index) {
                            Map news = newsData[index];
                            return NewsCard(
                              constraints: constraints,
                              newsTitle: news['news_title'],
                              newsBody: news['news_body'],
                              newsDate: news['news_time'].toDate(),
                              url: news['url'],
                            );
                          })
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
