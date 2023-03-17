import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';

class Formfield extends StatelessWidget {
  final String text;
  final BoxConstraints size;
  final bool isPassword;
  final bool isFilled;
  final Function(String) onChanged;

  const Formfield({
    super.key,
    required this.size,
    required this.text,
    required this.isPassword,
    required this.onChanged,
    required this.isFilled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: onChanged,
            style: TextStyle(
              fontSize: size.maxWidth * 0.04,
              color: secondary,
            ),
            obscureText: isPassword,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: isFilled ? secondary : Colors.redAccent,
                    width: 2,
                    style: BorderStyle.solid),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: isFilled ? secondary : Colors.redAccent,
                    width: 2,
                    style: BorderStyle.solid),
              ),
              hintText: text,
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: size.maxWidth * 0.04,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                fontFamily: 'Poppins',
              ),
            ),
          ),
           Visibility(
                  visible: !isFilled,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: Text(
                      '* Required field',
                      style: GoogleFonts.poppins(
                          color: Colors.redAccent, fontStyle: FontStyle.italic),
                    ),
                  ))
        ],
      ),
    );
  }
}
