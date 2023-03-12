import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import 'components/appBar.dart';

class ExpandNews extends StatelessWidget {
  final String newsTitle;
  final String newsBody;
  const ExpandNews({Key? key, required this.newsTitle, required this.newsBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: bgSecondary,
        appBar: appBar(context),
        body: Column(
          children: [
            Expanded(
                child: Container(
              decoration: const BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  topLeft: Radius.circular(40.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                child: ListTile(
                  title: Text(
                    newsTitle,
                    style: GoogleFonts.poppins(color: bgPrimary, fontWeight: FontWeight.w700, fontSize: constraints.maxWidth * 0.06),
                  ),
                  subtitle: Text(
                    newsBody,
                    style: GoogleFonts.poppins(color: bgPrimary, fontWeight: FontWeight.w300, fontSize: constraints.maxWidth * 0.04),
                  ),
                ),
              ),
            ))
          ],
        ),
      );
    });
  }
}
