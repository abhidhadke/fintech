import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../expand_news.dart';

class NewsCard extends StatelessWidget {
  final BoxConstraints constraints;
  final String newsTitle;
  final String newsBody;
  final DateTime newsDate;
  final String url;
  const NewsCard({
    super.key, required this.constraints, required this.newsTitle, required this.newsBody, required this.newsDate, required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgSecondary,
      child: ListTile(
        contentPadding:
        const EdgeInsets.fromLTRB(15, 12, 15, 12),
        title: Text(
          newsTitle,
          style: GoogleFonts.poppins(
              color: secondary,
              fontSize: constraints.maxWidth * 0.043,
              fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          newsBody,
          style: GoogleFonts.poppins(
              color: secondary,
              fontSize: constraints.maxWidth * 0.036,
              fontWeight: FontWeight.w400),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat.jm().format(newsDate),
              style: GoogleFonts.poppins(color: secondary),
            ),
            Text(
              DateFormat('EEE').format(newsDate),
              style: GoogleFonts.poppins(color: secondary),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ExpandNews(newsTitle: newsTitle, newsBody: newsBody, url: url,)));
        },
      ),
    );
  }
}