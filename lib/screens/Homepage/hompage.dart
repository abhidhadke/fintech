import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/constants.dart';
import 'package:fintech/network/model/users.dart' as user;
import 'package:flutter/material.dart';
import 'components/HomeCard.dart';
import 'components/stock_card.dart';

class Homepage extends StatefulWidget {
  final String uid;

  const Homepage({Key? key, required this.uid}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    // TODO: implement initState
    getUserDetails();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Scaffold(
            backgroundColor: bgSecondary,
            extendBodyBehindAppBar: false,
            body: Column(
              children: [
                SizedBox(
                  height: constraint.maxHeight * 0.17,
                ),
                Padding(
                  padding: EdgeInsets.all(constraint.maxWidth * 0.05),
                  child: Row(
                    children: [
                      SizedBox(
                        width: constraint.maxWidth * 0.4,
                        child: Text(
                          'Welcome, \n ${user.userName} !',
                          style: TextStyle(
                            fontSize: constraint.maxWidth * 0.06,
                            color: secondary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          color: btnColor,
                        ),
                        height: constraint.maxHeight * 0.1,
                        width: constraint.maxWidth * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${user.userTokens} fs',
                              style: TextStyle(
                                fontSize: constraint.maxWidth * 0.075,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    // height: constraint.maxHeight,
                    // width: constraint.maxWidth,
                    decoration: const BoxDecoration(
                      color: bgPrimary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        topLeft: Radius.circular(40.0),
                      ),
                    ),
                    child: ListView(
                      children: [
                        SizedBox(
                          width: constraint.maxWidth,
                          height: constraint.maxHeight * 0.18,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 8, bottom: 8),
                            child: StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('news_alerts')
                                  .orderBy('news_time', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      height: constraint.maxHeight * 0.05,
                                      child: const CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
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
                                    scrollDirection: Axis.horizontal,
                                    itemCount: userData.length,
                                    padding: const EdgeInsets.only(right: 5),
                                    itemBuilder: (context, index) {
                                      return HomeCard(
                                        constraint: constraint,
                                        title: userData[index]['news_title'],
                                      );
                                    });
                              },
                            ),
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
                            height: constraint.maxHeight * 0.4,
                            child: StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('company')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      height: constraint.maxHeight * 0.05,
                                      child: const CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
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
                                  physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: userData.length,
                                    padding: const EdgeInsets.only(right: 5),
                                    itemBuilder: (context, index) {
                                      return StocksCard(
                                        constraint: constraint,
                                        stockName: userData[index]['name'],
                                        stockLogo: userData[index]['link'],
                                        stockPrice:
                                            userData[index]['price'].toDouble(),
                                        stockChange: userData[index]['incdec']
                                            .toDouble(),
                                      );
                                    });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
