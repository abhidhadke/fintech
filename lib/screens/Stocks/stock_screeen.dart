import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/network/model/users.dart';
import 'package:fintech/screens/Stocks/components/RoundedButton.dart';
import 'package:fintech/screens/Stocks/components/bottomSheeet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../constants.dart';
import 'components/chartData.dart';

class StocksScreen extends StatefulWidget {
  final String stockName;
  final int stockPrice;

  const StocksScreen(
      {Key? key, required this.stockName, required this.stockPrice})
      : super(key: key);

  @override
  State<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen>
    with SingleTickerProviderStateMixin {
  List<ChartData> chartData = <ChartData>[];
  int cnt = 0;
  int amount = 0;

  @override
  void initState() {
    getDataFromFireStore();
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    debugPrint(widget.stockName);
    await FirebaseFirestore.instance
        .collection("history")
        .doc(widget.stockName)
        .get()
        .then((value) => storeData(value));
    amount = await checkCount(widget.stockName);
  }

  storeData(DocumentSnapshot<Map<String, dynamic>> value) {
    List<ChartData> list = [];
    debugPrint('${value.exists}');
    var docData = value.data();
    debugPrint('${docData?.length}');
    int docLen = docData?.keys.length ?? 0;
    for (int i = 1; i <= docLen ~/ 2; i++) {
      list.add(ChartData(
          x: docData!['time$i'].toDate(), y: docData['price$i'].toDouble()));
    }
    setState(() {
      //debugPrint('$list');
      chartData = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('inside stock:${widget.stockName}');
    return LayoutBuilder(
      builder: (context, constraints) {
        return WillPopScope(
          onWillPop: () {
            Navigator.pop(context, true);
            return Future.value(false);
          },
          child: Scaffold(
            backgroundColor: bgSecondary,
            appBar: _appBar(constraints),
            body: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SfCartesianChart(
                    primaryXAxis: DateTimeAxis(
                        title: AxisTitle(
                            text: 'Time', alignment: ChartAlignment.near, textStyle: GoogleFonts.poppins(color: secondary.withOpacity(0.4)))),
                    primaryYAxis: NumericAxis(
                        title: AxisTitle(
                            text: 'Price', alignment: ChartAlignment.near, textStyle: GoogleFonts.poppins(color: secondary.withOpacity(0.4)))),
                    enableAxisAnimation: true,
                    series: <ChartSeries<ChartData, DateTime>>[
                      LineSeries<ChartData, DateTime>(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          xAxisName: 'Time',
                          yAxisName: 'Price',
                          width: 4.0),
                    ]),
                const SizedBox(
                  height: 30,
                ),
                Card(
                  elevation: 10,
                  color: bgPrimary,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Current Price: ${widget.stockPrice} T', style: GoogleFonts.poppins(
                    fontSize: constraints.maxWidth * 0.04,
                    color: secondary,
                    fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                RoundedButton(
                  text: 'BUY',
                  press: () async {
                    openBottomSheet(context, constraints, cnt, true,
                        widget.stockName, widget.stockPrice, amount);
                  },
                  color: bgPrimary,
                  textColor: btnColor,
                  length: 0.85,
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  text: 'SELL',
                  press: () async {
                    openBottomSheet(context, constraints, cnt, false,
                        widget.stockName, widget.stockPrice, amount);
                  },
                  color: bgPrimary,
                  textColor: btnColor,
                  length: 0.85,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _appBar(BoxConstraints constraints) {
    return AppBar(
      backgroundColor: bgSecondary,
      leading: IconButton(
        onPressed: () async {
          Navigator.pop(context, true);
        },
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: secondary,
        ),
      ),
      title: Text(widget.stockName),
      titleTextStyle: GoogleFonts.poppins(
          fontSize: constraints.maxWidth * 0.06,
          color: secondary,
          fontWeight: FontWeight.w600),
    );
  }
}
