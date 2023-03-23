import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';

AppBar appBarHome(BoxConstraints constraint) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 5,
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/mcoe_logo.png'),
      )
    ],
    title: Text(
      'Wall Street Harvest',
      style: GoogleFonts.poppins(
          color: bgSecondary,
          fontWeight: FontWeight.w700,
          fontSize: constraint.maxWidth * 0.07),
    ),
  );
}