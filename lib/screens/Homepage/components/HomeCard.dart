import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../News/News_page.dart';

class HomeCard extends StatelessWidget {
  final BoxConstraints constraint;
  final String title;

  const HomeCard({
    super.key,
    required this.constraint,
    required this.title,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: SizedBox(
        width: constraint.maxWidth * 0.6,
        child: Card(
          color: secondary,
          elevation: 4,
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: constraint.maxWidth * 0.04),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'Read more',
              style: GoogleFonts.poppins(
                color: Colors.blue[800],
                  fontWeight: FontWeight.w500,
                  fontSize: constraint.maxWidth * 0.03),
            ),
          ),
        ),
      ),
    );
  }
}
