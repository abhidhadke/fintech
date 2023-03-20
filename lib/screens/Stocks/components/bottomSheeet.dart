import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../../network/model/users.dart';
import 'buyCOunter.dart';

openBottomSheet(BuildContext context, BoxConstraints constraints, int cnt,
    bool isBuy, String stockName, int stockPrice, int currentAmt) {
  bool isLoading = false;

  return isBuy
      ? showModalBottomSheet(
          elevation: 10,
          backgroundColor: Colors.amber,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          context: context,
          builder: (ctx) => StatefulBuilder(
                builder: (context, StateSetter setState) {
                  return Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * 0.35,
                      color: Colors.transparent,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Row(
                          children: [
                            Text(
                              'Stock Amount:',
                              style: GoogleFonts.poppins(
                                  fontSize: constraints.maxWidth * 0.04,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.3,
                              child: CounterCard(
                                count: cnt,
                                increment: () {
                                  setState(() {
                                    cnt++;
                                  });
                                },
                                decrement: () {
                                  if (cnt > 0) {
                                    setState(() {
                                      cnt--;
                                    });
                                  }
                                },
                                constraints: constraints,
                              ),
                            ),
                          ]
                              .map((e) => Padding(
                                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                                    child: e,
                                  ))
                              .toList(),
                        ),
                        Row(
                          children: [
                            Text(
                              'Stock Price:',
                              style: GoogleFonts.poppins(
                                  fontSize: constraints.maxWidth * 0.04,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.017,
                            ),
                            SizedBox(
                                width: constraints.maxWidth * 0.2,
                                child: Card(
                                    elevation: 3,
                                    shadowColor: secondary,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: constraints.maxWidth * 0.02,
                                          height: constraints.maxWidth * 0.1,
                                          alignment: Alignment.center,
                                          color: Colors.white,
                                          child: Text('${cnt * stockPrice} T'),
                                        )))),
                          ]
                              .map((e) => Padding(
                                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                                    child: e,
                                  ))
                              .toList(),
                        ),
                        Row(
                          children: [
                            Text(
                              'Current holding:',
                              style: GoogleFonts.poppins(
                                  fontSize: constraints.maxWidth * 0.04,
                                  fontWeight: FontWeight.w600),
                            ),

                            SizedBox(
                                width: constraints.maxWidth * 0.2,
                                child: Card(
                                    elevation: 3,
                                    shadowColor: secondary,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: constraints.maxWidth * 0.02,
                                          height: constraints.maxWidth * 0.1,
                                          alignment: Alignment.center,
                                          color: Colors.white,
                                          child: Text('$currentAmt'),
                                        )))),
                          ]
                              .map((e) => Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                            child: e,
                          ))
                              .toList(),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                'Your Balance:',
                                style: GoogleFonts.poppins(
                                    fontSize: constraints.maxWidth * 0.04,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.2,
                              child: Card(
                                  elevation: 3,
                                  shadowColor: secondary,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: constraints.maxWidth * 0.02,
                                        height: constraints.maxWidth * 0.1,
                                        alignment: Alignment.center,
                                        color: Colors.white,
                                        child: Text('$userTokens T'),
                                      ))),
                            ),
                            const Spacer(),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20.0)),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                //width: length.width,
                                color: bgPrimary,
                                child: TextButton(
                                    onPressed: () async {
                                      setState((){
                                        isLoading = true;
                                      });
                                      int check = await buyStocks(stockName, cnt, stockPrice);
                                      if(check == 1){
                                        Navigator.pop(context);
                                      }
                                      else{
                                        setState((){
                                          isLoading = false;
                                        });
                                      }
                                    },
                                    //buyStocks(widget.stockName, cnt, widget.stockPrice),
                                    child: isLoading ? const CircularProgressIndicator() : Text(
                                      'Checkout',
                                      style: GoogleFonts.poppins(
                                        color: secondary,
                                        fontSize: 20,
                                      )
                                    )),
                              ),
                            )
                          ]),
                        ),
                      ]));
                },
              ))
      : showModalBottomSheet(
          elevation: 10,
          backgroundColor: Colors.amber,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          context: context,
          builder: (ctx) => StatefulBuilder(
                builder: (context, StateSetter setState) {
                  return Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * 0.35,
                      color: Colors.transparent,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Row(
                          children: [
                            Text(
                              'Stock Amount:',
                              style: GoogleFonts.poppins(
                                  fontSize: constraints.maxWidth * 0.04,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.3,
                              child: CounterCard(
                                count: cnt,
                                increment: () async {
                                  int maxAmt = await checkCount(stockName);
                                  if (cnt < maxAmt) {
                                    setState(() {
                                      cnt++;
                                    });
                                  }
                                },
                                decrement: () {
                                  if (cnt > 0) {
                                    setState(() {
                                      cnt--;
                                    });
                                  }
                                },
                                constraints: constraints,
                              ),
                            ),
                          ]
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: e,
                                  ))
                              .toList(),
                        ),
                        Row(
                          children: [
                            Text(
                              'Stock Price:',
                              style: GoogleFonts.poppins(
                                  fontSize: constraints.maxWidth * 0.04,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.017,
                            ),
                            SizedBox(
                                width: constraints.maxWidth * 0.2,
                                child: Card(
                                    elevation: 3,
                                    shadowColor: secondary,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: constraints.maxWidth * 0.02,
                                          height: constraints.maxWidth * 0.1,
                                          alignment: Alignment.center,
                                          color: Colors.white,
                                          child: Text('${cnt * stockPrice} T'),
                                        )))),
                          ]
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: e,
                                  ))
                              .toList(),
                        ),
                        Row(
                          children: [
                            Text(
                              'Current holding:',
                              style: GoogleFonts.poppins(
                                  fontSize: constraints.maxWidth * 0.04,
                                  fontWeight: FontWeight.w600),
                            ),

                            SizedBox(
                                width: constraints.maxWidth * 0.2,
                                child: Card(
                                    elevation: 3,
                                    shadowColor: secondary,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: constraints.maxWidth * 0.02,
                                          height: constraints.maxWidth * 0.1,
                                          alignment: Alignment.center,
                                          color: Colors.white,
                                          child: Text('$currentAmt'),
                                        )))),
                          ]
                              .map((e) => Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                            child: e,
                          ))
                              .toList(),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                'Your Balance:',
                                style: GoogleFonts.poppins(
                                    fontSize: constraints.maxWidth * 0.04,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.2,
                              child: Card(
                                  elevation: 3,
                                  shadowColor: secondary,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: constraints.maxWidth * 0.02,
                                        height: constraints.maxWidth * 0.1,
                                        alignment: Alignment.center,
                                        color: Colors.white,
                                        child: Text('$userTokens T'),
                                      ))),
                            ),
                            const Spacer(),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20.0)),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                //width: length.width,
                                color: bgPrimary,
                                child: TextButton(
                                    onPressed: () async {
                                      setState((){
                                        isLoading = true;
                                      });
                                      int check = await sellStocks(stockName, cnt, stockPrice);
                                      if(check == 1){
                                        Navigator.pop(context);
                                      }
                                      else{

                                      }
                                    },
                                    //buyStocks(widget.stockName, cnt, widget.stockPrice),
                                    child: isLoading ? const CircularProgressIndicator() : Text(
                                      'Checkout',
                                      style: GoogleFonts.poppins(
                                        color: secondary,
                                        fontSize: 20,
                                      )
                                    )),
                              ),
                            )
                          ]),
                        ),
                      ]));
                },
              ));

}


