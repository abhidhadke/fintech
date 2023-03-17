import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../network/model/users.dart';
import 'buyCOunter.dart';

openBottomSheet(BuildContext context, BoxConstraints constraints, int cnt,
    bool isBuy, String stockName, int stockPrice) {
  return isBuy
      ? showModalBottomSheet(
          elevation: 10,
          backgroundColor: Colors.amber,
          context: context,
          builder: (ctx) => StatefulBuilder(
                builder: (context, StateSetter setState) {
                  return Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * 0.3,
                      color: Colors.white54,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.4,
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
                            ),
                          ),
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            child: Container(
                              //width: length.width,
                              color: bgPrimary,
                              child: TextButton(
                                  onPressed: () {
                                    buyStocks(stockName, cnt, stockPrice);
                                  },
                                  //buyStocks(widget.stockName, cnt, widget.stockPrice),
                                  child: const Text(
                                    'Checkout',
                                    style: TextStyle(
                                      color: secondary,
                                      fontSize: 25,
                                    ),
                                  )),
                            ),
                          ),
                        ]
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: e,
                                ))
                            .toList(),
                      ));
                },
              ))
      : showModalBottomSheet(
          elevation: 10,
          backgroundColor: Colors.amber,
          context: context,
          builder: (ctx) => StatefulBuilder(
                builder: (context, StateSetter setState) {
                  return Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * 0.3,
                      color: Colors.white54,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.4,
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
                            ),
                          ),
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            child: Container(
                              //width: length.width,
                              color: bgPrimary,
                              child: TextButton(
                                  onPressed: () {
                                    sellStocks(stockName, cnt, stockPrice);
                                  },
                                  //buyStocks(widget.stockName, cnt, widget.stockPrice),
                                  child: const Text(
                                    'Checkout',
                                    style: TextStyle(
                                      color: secondary,
                                      fontSize: 25,
                                    ),
                                  )),
                            ),
                          ),
                        ]
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: e,
                                ))
                            .toList(),
                      ));
                },
              ));
}
