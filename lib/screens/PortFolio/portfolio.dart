import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/constants.dart';
import 'package:fintech/screens/PortFolio/components/appBar.dart';
import 'package:flutter/material.dart';
import 'package:fintech/network/model/users.dart' as user;
import 'package:google_fonts/google_fonts.dart';

import '../../network/model/users.dart';

class PortFolio extends StatefulWidget {
  const PortFolio({Key? key}) : super(key: key);

  @override
  State<PortFolio> createState() => _PortFolioState();
}

class _PortFolioState extends State<PortFolio> {
  final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  late QuerySnapshot<Map<String, dynamic>> stockData;
  Map<String, dynamic>? allFields = {};
  var allData = [];
  bool isLoading = true;

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  getUserDetails() async {
    await user.setData();
    final db = FirebaseFirestore.instance;
    stockData = await db.collection('company').get();
    allData = stockData.docs.map((e) => e.data()).toList();
    List<String> exclude = ['tokens', 'username'];
    await docRef.get().then((doc) {
      if (doc.exists) {
        allFields = doc.data();
        for (String i in exclude) {
          if (allFields!.containsKey(i)) {
            allFields!.remove(i);
          }
        }
      }
    });
    debugPrint('$allFields');
    setState(() {
      isLoading = false;
    });
  }

  Map<String, dynamic> getMapByName(String name) {
    for (var map in allData) {
      if (map["name"] == name) {
        return map;
      }
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    List stockNames = allFields!.keys.toList();
    List stockCount = allFields!.values.toList();
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: bgSecondary,
        appBar: appBar(context),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),
                  Text(
                    'Hello $userName!',
                    style: GoogleFonts.poppins(
                      fontSize: 40,
                      color: secondary,
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.02,
                  ),
                  Text(
                    'Your Current Holdings Include\nthe following Stocks ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: secondary,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),
                  Expanded(
                    child: isLoading
                        ? const Align(
                            alignment: Alignment.topCenter,
                            child: CircularProgressIndicator())
                        : _checkList(stockNames, stockCount, constraints),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _checkList(List stockNames, List stockCount, BoxConstraints constraints) {
    if (stockCount.every((element) => element == 0)) {
      return Center(
        child: Text(
          'No Stocks bought',
          style: GoogleFonts.poppins(color: secondary),
        ),
      );
    } else {
      return _listView(stockNames, stockCount, constraints);
    }
  }

  _listView(List stockNames, List stockCount, BoxConstraints constraints) {
    return ListView.builder(
        itemCount: allFields!.length,
        itemBuilder: (context2, index) {
          Map price = getMapByName(stockNames[index]);
          var stockPrice = price['price'] ?? 0;
          if (stockCount[index] != 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(
                    stockNames[index],
                    style: GoogleFonts.poppins(
                        fontSize: constraints.maxWidth * 0.045,
                        fontWeight: FontWeight.w600),
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'stocks: ${stockCount[index]}',
                            style: GoogleFonts.poppins(
                                fontSize: constraints.maxWidth * 0.035,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'holdings: ${stockCount[index] * stockPrice} T',
                            style: GoogleFonts.poppins(
                                fontSize: constraints.maxWidth * 0.035,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }else{
            return const SizedBox();
          }
        });
  }
}
