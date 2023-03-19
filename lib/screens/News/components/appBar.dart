import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';

appBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    backgroundColor: bgSecondary,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context, true);
      },
      icon: const Icon(Icons.arrow_back_ios_rounded),
      color: secondary,
    ),
    title: Text(
      'Latest News',
      style: GoogleFonts.poppins(
          fontSize: 25, color: secondary, fontWeight: FontWeight.w600),
    ),
  );
}
