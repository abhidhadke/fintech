import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/constants.dart';
import 'package:flutter/material.dart';
import 'components/HomeCard.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
                          'Welcome, \nUsername !',
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
                              '20000 fs',
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
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
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
                                      child: const CircularProgressIndicator(color: Colors.blue,),
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
                                        body: userData[index]['news_body'],
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
                            child: ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context3, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.pink,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      width: constraint.maxWidth * 0.8,
                                      height: constraint.maxHeight * 0.15,
                                    ),
                                  );
                                }),
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
