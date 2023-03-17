import 'package:flutter/material.dart';
import 'package:fintech/constants.dart' as Constants;

class CounterCard extends StatelessWidget {
  const CounterCard({
    super.key,
    required this.count,
    required this.increment,
    required this.decrement,
  });

  final int count;

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
          width: 120,
          height: 100,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 40,
                child: TextButton(
                  onPressed: decrement,
                  child: const Text(
                    '-',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 40,
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