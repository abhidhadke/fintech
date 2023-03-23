import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/constants.dart';
import 'package:fintech/network/model/users.dart' as user;
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../PortFolio/portfolio.dart';
import 'components/appBar.dart';
import 'components/newsList.dart';
import 'components/stocksList.dart';

class Homepage extends StatefulWidget {
  final String uid;

  const Homepage({Key? key, required this.uid}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var stockData = [];
  var newsData = [];
  bool stockLoading = true;
  bool newsLoading = true;
  final RefreshController _newsRefreshController =
      RefreshController(initialRefresh: false);
  final RefreshController _stockRefreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getStocksData();
    getNewsData();
  }

  getUserDetails() async {
    await user.setData();
    final db = FirebaseFirestore.instance;
    final data = await db.collection('users').doc(user.uid).get();
    user.userName = data.data()!['username'];
    user.userTokens = data.data()!['tokens'];
    setState(() {});
    //debugPrint(UserTokens);
  }

  getStocksData() async {
    final data = await FirebaseFirestore.instance.collection('company').get();
    stockData = data.docs.map((e) => e.data()).toList();
    debugPrint('getting stocks data');
    setState(() {
      stockLoading = false;
      _stockRefreshController.refreshCompleted();
    });
  }

  getNewsData() async {
    final news =
        await FirebaseFirestore.instance.collection('news_alerts').get();
    newsData = news.docs.map((e) => e.data()).toList();
    debugPrint('getting news Data');
    setState(() {
      newsLoading = false;
      _newsRefreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SafeArea(
          child: Scaffold(
              backgroundColor: btnColor,
              extendBodyBehindAppBar: false,
              appBar: appBarHome(constraint),
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    pinned: true,
                    floating: false,
                    snap: false,
                    expandedHeight: constraint.maxHeight * 0.3,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  width: constraint.maxWidth * 0.4,
                                  child:
                                      Image.asset('assets/cascode_Logo.png')),
                              SizedBox(
                                  width: constraint.maxWidth * 0.4,
                                  child: Image.asset('assets/josh_logo.png'))
                            ]
                                .map((e) => Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 0),
                                      child: e,
                                    ))
                                .toList(),
                          ),
                          Padding(
                            padding: EdgeInsets.all(constraint.maxWidth * 0.05),
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: bgSecondary,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text(
                                    'Welcome,\n${user.userName}!',
                                    style: TextStyle(
                                      fontSize: constraint.maxWidth * 0.06,
                                      color: secondary,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40.0)),
                                    color: bgSecondary,
                                  ),
                                  height: constraint.maxHeight * 0.08,
                                  width: constraint.maxWidth * 0.35,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        child: Text(
                                          '${user.userTokens} T',
                                          style: TextStyle(
                                              fontSize:
                                                  constraint.maxWidth * 0.075,
                                              fontWeight: FontWeight.w600,
                                              color: secondary),
                                        ),
                                        onTap: () async {
                                          var push = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PortFolio()));
                                          if (push == true) {
                                            await getUserDetails();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    var push = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PortFolio()));
                                    if (push == true) {
                                      await getUserDetails();
                                    }
                                  },
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: bgSecondary,
                                    size: constraint.maxWidth * 0.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      // width: constraint.maxWidth,
                      decoration: const BoxDecoration(
                        color: bgSecondary,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          topLeft: Radius.circular(40.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            buildNewsList(constraint,newsLoading,newsData,getUserDetails,getNewsData),
                            buildStocksList(constraint,stockLoading,getStocksData,getUserDetails,_stockRefreshController,stockData),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }






}
