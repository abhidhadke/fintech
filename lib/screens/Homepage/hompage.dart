import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/constants.dart';
import 'package:fintech/network/model/users.dart' as user;
import 'package:fintech/screens/Stocks/stock_screeen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../News/News_page.dart';
import '../PortFolio/portfolio.dart';
import 'components/HomeCard.dart';
import 'components/stock_card.dart';

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
    //TODO: Implement a timeout function
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
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 5,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/mcoe_logo.png'),
                  )
                ],
                title: Text(
                  'Wall Street Harvest',
                  style: GoogleFonts.poppins(
                      color: bgSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: constraint.maxWidth * 0.07),
                ),
              ),
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
                            SizedBox(
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
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  constraint.maxWidth * 0.05,
                                  constraint.maxWidth * 0.1,
                                  constraint.maxWidth * 0.05,
                                  0.0),
                              child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(15.0),
                                  )),
                                  width: constraint.maxWidth,
                                  height: constraint.maxHeight * 0.6,
                                  child: stockLoading
                                      ? const Align(
                                          alignment: Alignment.topCenter,
                                          child: CircularProgressIndicator())
                                      : SmartRefresher(
                                    header: const WaterDropMaterialHeader(
                                      backgroundColor: bgSecondary,
                                      color: secondary,
                                    ),
                                          enablePullDown: true,
                                          onRefresh: getStocksData,
                                          enablePullUp: false,
                                          controller: _stockRefreshController,
                                          child: ListView.builder(
                                              itemCount: stockData.length,
                                              itemBuilder: (context, index) {
                                                Map stockMap = stockData[index];
                                                return InkWell(
                                                  onTap: () async {
                                                    var push = await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) => StocksScreen(
                                                                stockName:
                                                                    stockMap[
                                                                        'name'],
                                                                stockPrice:
                                                                    stockMap[
                                                                        'price'])));
                                                    if (push == true) {
                                                      await getUserDetails();
                                                      await getStocksData();
                                                    }
                                                  },
                                                  child: StocksCard(
                                                      constraint: constraint,
                                                      stockName:
                                                          stockMap['name'],
                                                      stockLogo:
                                                          stockMap['link'],
                                                      stockPrice:
                                                          stockMap['price']
                                                              .toDouble(),
                                                      stockChange:
                                                          stockMap['incdec']
                                                              .toDouble()),
                                                );
                                              }),
                                        )),
                            ),
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
