import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'components/chartData.dart';

class StocksScreen extends StatefulWidget {
  final String stockName;

  const StocksScreen({Key? key, required this.stockName}) : super(key: key);

  @override
  State<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  List<ChartData> chartData = <ChartData>[];

  @override
  void initState() {
    // TODO: implement initState
    getDataFromFireStore();
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    List<ChartData> list = [];
    var snapShotsValue =
        await FirebaseFirestore.instance.collection("history").doc(widget.stockName).get();

    var docData = snapShotsValue.data();
    int docLen = docData?.keys.length ?? 0;
    for(int i = 1; i <= (docLen / 2); i++){
      list.add(ChartData(x: docData!['time$i'].toDate(), y: docData['price$i'].toDouble()));
    }

    setState(() {
      //debugPrint('$list');
      chartData = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('inside stock: ${widget.stockName}');
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: _appBar(constraints),
          body: Column(
            children: [
              SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                primaryYAxis: NumericAxis(),
            series: <ChartSeries<ChartData, DateTime>>[
              LineSeries<ChartData, DateTime>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y),
            ]
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
