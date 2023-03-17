import 'package:fintech/constants.dart';
import 'package:fintech/screens/PortFolio/components/appBar.dart';
import 'package:flutter/material.dart';

class PortFolio extends StatefulWidget {
  const PortFolio({Key? key}) : super(key: key);

  @override
  State<PortFolio> createState() => _PortFolioState();
}

class _PortFolioState extends State<PortFolio> {
  @override
  Widget build(BuildContext context) {
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
                Text(
                  'Hello Username',
                  style: TextStyle(
                    color: secondary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
