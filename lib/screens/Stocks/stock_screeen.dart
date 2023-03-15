import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/screens/Stocks/components/RoundedButton.dart';
import 'package:fintech/screens/Stocks/components/buyCOunter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants.dart';

import 'components/chartData.dart';

class StocksScreen extends StatefulWidget {
  final String stockName;

  const StocksScreen({Key? key, required this.stockName}) : super(key: key);

  @override
  State<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  AnimationStatus _status = AnimationStatus.dismissed;
  List<ChartData> chartData = <ChartData>[];

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
      ..addStatusListener((status) {
        _status = status;
      });
  }

  Future<void> getDataFromFireStore() async {
    List<ChartData> list = [];
    var snapShotsValue = await FirebaseFirestore.instance
        .collection("history")
        .doc(widget.stockName)
        .get();

    var docData = snapShotsValue.data();
    int docLen = docData?.keys.length ?? 0;
    for (int i = 1; i <= (docLen / 2); i++) {
      list.add(ChartData(
          x: docData!['time$i'].toDate(), y: docData['price$i'].toDouble()));
    }

    setState(() {
      //debugPrint('$list');
      chartData = list;
    });
  }

  void _show(BuildContext ctx, int cnt) {}

  int cnt = 0;

  @override
  Widget build(BuildContext context) {
    debugPrint('inside stock: ${widget.stockName}');
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: _appBar(constraints),
          body: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SfCartesianChart(
                  primaryXAxis: DateTimeAxis(),
                  primaryYAxis: NumericAxis(),
                  series: <ChartSeries<ChartData, DateTime>>[
                    LineSeries<ChartData, DateTime>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y),
                  ]),
              const SizedBox(
                height: 30,
              ),
              Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0015)
                  ..rotateX(pi * _animation.value),
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: _animation.value <= 0.5
                      ? InkWell(
                          onTap: () {
                            _controller.forward();
                          },
                          child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                color: Colors.deepOrange,
                              ),
                              width: constraints.maxWidth * 0.85,
                              height: 100,
                              child: const Center(
                                  child: Text(
                                'Your Info',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ))),
                        )
                      : InkWell(
                          onTap: () {
                            _controller.reverse();
                          },
                          child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                color: Colors.deepOrange,
                              ),
                              width: constraints.maxWidth * 0.85,
                              height: 100,
                              //color: Colors.deepOrange,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(pi),
                                child: const RotatedBox(
                                  quarterTurns: 2,
                                  child: Center(
                                    child: Text(
                                      'You own xxx amount of yyy stock amounting to zzz fs',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundedButton(
                text: 'BUY',
                press: () {
                  showModalBottomSheet(
                      elevation: 10,
                      backgroundColor: Colors.amber,
                      context: context,
                      builder: (ctx) => StatefulBuilder(
                       builder:  (context, StateSetter setState){
                         return  Container(
                             width: 300,
                             height: 250,
                             color: Colors.white54,
                             alignment: Alignment.center,
                             child: Row(
                               children: [
                                 CounterCard(
                                   count: cnt,
                                   increment: () {
                                     setState(() {
                                       cnt++;
                                     });
                                   },
                                   decrement: () {
                                     if(cnt > 0){
                                       setState(() {
                                         cnt--;
                                       });
                                     }

                                   },
                                 ),
                               ],
                             ));
                       },
                      ));
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
                press: () {},
                color: bgPrimary,
                textColor: btnColor,
                length: 0.85,
              ),
            ],
          ),
        );
      },
    );
  }

  _appBar(BoxConstraints constraints) {
    return AppBar(
      leading: IconButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_rounded),
      ),
      title: Text(widget.stockName),
      titleTextStyle: GoogleFonts.poppins(
          fontSize: constraints.maxWidth * 0.06,
          color: Colors.black,
          fontWeight: FontWeight.w700),
    );
  }
}
