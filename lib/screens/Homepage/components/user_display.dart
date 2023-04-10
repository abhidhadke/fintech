import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../PortFolio/portfolio.dart';

class UserDisplay extends StatelessWidget {
  const UserDisplay({
    super.key,
    required this.userDocument,
    required this.constraint,
  });

  final Map<String, dynamic> userDocument;
  final BoxConstraints constraint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: bgSecondary,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Welcome,\n${userDocument['username']} !',
            style: TextStyle(
              fontSize: constraint.maxWidth * 0.06,
              color: secondary,
            ),
          ),
        ),
        const Spacer(),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            color: bgSecondary,
          ),
          height: constraint.maxHeight * 0.08,
          width: constraint.maxWidth * 0.35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                child: Text(
                  '${userDocument['tokens']} T',
                  style: TextStyle(
                      fontSize: constraint.maxWidth * 0.075,
                      fontWeight: FontWeight.w600,
                      color: secondary),
                ),
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PortFolio()));
                },
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PortFolio()));

          },
          child: Icon(
            Icons.chevron_right,
            color: bgSecondary,
            size: constraint.maxWidth * 0.09,
          ),
        ),
      ],
    );
  }
}