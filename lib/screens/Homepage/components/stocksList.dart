import 'package:fintech/screens/Homepage/components/stock_card.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../constants.dart';
import '../../Stocks/stock_screeen.dart';

Padding buildStocksList(BoxConstraints constraint, bool stockLoading, Function() getStocksData, Function() getUserDetails,RefreshController stockRefreshController, List stockData, ) {
  return Padding(
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
          controller: stockRefreshController,
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
        )
    ),
  );
}