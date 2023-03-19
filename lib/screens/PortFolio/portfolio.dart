import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/constants.dart';
import 'package:fintech/screens/Homepage/components/stock_card.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    getUserDetails();
    super.initState();
  }

  final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  var excludedfields;
  late Map<String, dynamic>? allfields;

  getUserDetails() async {
    await user.setData();
    final db = FirebaseFirestore.instance;
    final data = await db.collection('users').doc(user.uid).get();
    user.userName = data.data()!['username'];
    user.userTokens = data.data()!['tokens'];

    List<String> exclude = ['tokens', 'username'];

    docRef.get().then((doc) {
      if (doc.exists) {
        allfields = doc.data();
        for (String i in exclude) {
          if (allfields!.containsKey(i)) {
            allfields!.remove(i);
          }
          ;
        }
        //excludedfields = allfields?.keys.toList().sublist(3);
      }
    });

    setState(() {});
    //debugPrint(UserTokens);
  }

  @override
  Widget build(BuildContext context) {
    List stockNames = allfields!.keys.toList();
    List stockCount = allfields!.values.toList();
    return Scaffold(
      backgroundColor: bgSecondary,
      appBar: appBar(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: constraints.maxHeight*0.05,),
                Text(
                  'Hello $userName !',
                  style: const TextStyle(
                    fontSize: 40,
                    color: secondary,
                  ),
                ),
                SizedBox(height: constraints.maxHeight*0.02,),
                const Text(
                  'Your Current Holdings Include\nthe following Stocks ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondary,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: constraints.maxHeight*0.05,),
                Expanded(
                  child: ListView.builder(
                      itemCount: allfields!.length,
                      itemBuilder: (context2, index) {
                        return (stockCount[index] != 0)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 4,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(10),
                                    title: Text(
                                      stockNames[index],
                                      style: GoogleFonts.poppins(
                                          fontSize:
                                              constraints.maxWidth * 0.045,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'stocks: ${stockCount[index]}',
                                          style: GoogleFonts.poppins(
                                              fontSize:
                                                  constraints.maxWidth * 0.035,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container();
                      }),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
