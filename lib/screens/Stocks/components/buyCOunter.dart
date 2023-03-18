import 'package:flutter/material.dart';
import 'package:fintech/constants.dart' as Constants;

class CounterCard extends StatelessWidget {
  const CounterCard({
    super.key,
    required this.count,
    required this.increment,
    required this.decrement, required this.constraints,
  });

  final int count;
  final BoxConstraints constraints;
  final Function() increment;
  final Function() decrement;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Constants.secondary,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: constraints.maxWidth * 0.05,
          height: constraints.maxWidth * 0.1,
          color: Colors.white,
          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: constraints.maxWidth * 0.1,
                child: TextButton(
                  onPressed: decrement,
                  child: const Text(
                    '-',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                width: constraints.maxWidth * 0.05,
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: constraints.maxWidth * 0.1,
                child: TextButton(
                  onPressed: increment,
                  child: const Text(
                    '+',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CounterCard(
// maxWidth: constraints.maxWidth,
// maxHeight: constraints.maxHeight,
// count: cnt,
// increment: () {
// setState(() {
// cnt++;
// });
// },
// decrement: () {
// setState(() {
// cnt--;
// });
// },
// ),