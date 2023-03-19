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
  late AnimationController _controller;
  late Animation _animation;
  List<ChartData> chartData = <ChartData>[];
  int cnt = 0;
  int amount = 0;

  @override
  void initState() {
    // TODO: implement initState
    getDataFromFireStore();
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {});
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
                // Transform(
                //   alignment: FractionalOffset.center,
                //   transform: Matrix4.identity()
                //     ..setEntry(3, 2, 0.0015)
                //     ..rotateX(pi * _animation.value),
                //   child: Container(
                //     decoration: const BoxDecoration(
                //         borderRadius: BorderRadius.all(Radius.circular(20.0))),
                //     child: _animation.value <= 0.5
                //         ? InkWell(
                //             onTap: () {
                //               _controller.forward();
                //             },
                //             child: Container(
                //                 decoration: const BoxDecoration(
                //                   borderRadius:
                //                       BorderRadius.all(Radius.circular(20.0)),
                //                   color: Colors.deepOrange,
                //                 ),
                //                 width: constraints.maxWidth * 0.85,
                //                 height: 100,
                //                 child: const Center(
                //                     child: Text(
                //                   'Your Info\n(Tap Here)',
                //                   style: TextStyle(
                //                       fontSize: 20, color: Colors.white),
                //                 ))),
                //           )
                //         : InkWell(
                //             onTap: () {
                //               _controller.reverse();
                //             },
                //             child: Container(
                //                 decoration: const BoxDecoration(
                //                   borderRadius:
                //                       BorderRadius.all(Radius.circular(20.0)),
                //                   color: Colors.deepOrange,
                //                 ),
                //                 width: constraints.maxWidth * 0.85,
                //                 height: 100,
                //                 //color: Colors.deepOrange,
                //                 child: Transform(
                //                   alignment: Alignment.center,
                //                   transform: Matrix4.rotationY(pi),
                //                   child: const RotatedBox(
                //                     quarterTurns: 2,
                //                     child: Center(
                //                       child: Text(
                //                         'You own xxx amount of yyy stock amounting to zzz fs',
                //                         textAlign: TextAlign.center,
                //                         style: TextStyle(
                //                             fontSize: 20, color: Colors.white),
                //                       ),
                //                     ),
                //                   ),
                //                 )),
                //           ),
                //   ),
                // ),
                SizedBox(
                  width: constraints.maxWidth * 0.5,
                  child: Card(
                    elevation: 10,
                    color: bgPrimary,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Text('Current Price: ', style: GoogleFonts.poppins(
                          fontSize: constraints.maxWidth * 0.04,
                          color: secondary,
                          fontWeight: FontWeight.w600),
                          ),
                          Text('${widget.stockPrice} T', style: GoogleFonts.poppins(
                              fontSize: constraints.maxWidth * 0.04,
                              color: secondary,
                              fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
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
