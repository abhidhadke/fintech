import 'package:flutter/material.dart';
import 'package:fintech/constants.dart' as Constants;

class CounterCard extends StatelessWidget {
  const CounterCard({
    super.key,
    required this.maxWidth,
    required this.maxHeight,
    required this.count,
    required this.increment,
    required this.decrement,
  });

  final double maxWidth;
  final double maxHeight;
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
          width: maxWidth * 0.3,
          height: maxHeight * 0.05,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: maxWidth * 0.1,
                child: TextButton(
                  onPressed: decrement,
                  child: const Text(
                    '-',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                width: maxWidth * 0.08,
                child: Text(
                  '${count}',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: maxWidth * 0.1,
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