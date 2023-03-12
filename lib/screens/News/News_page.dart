import 'package:fintech/constants.dart';
import 'package:fintech/screens/News/expand_news.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'components/appBar.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
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
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                    return Card(
                      color: bgSecondary,
                      child: ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
                        title: Text('News title', style: GoogleFonts.poppins(color: secondary, fontSize: constraints.maxWidth * 0.043, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis,),
                        subtitle: Text(dummy, style: GoogleFonts.poppins(color: secondary, fontSize: constraints.maxWidth * 0.036, fontWeight: FontWeight.w400), maxLines: 2, overflow: TextOverflow.ellipsis,),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('9:40 am', style: GoogleFonts.poppins(color: secondary),),
                            Text('Thu', style: GoogleFonts.poppins(color: secondary),),
                          ],
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ExpandNews()));
                        },
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }


}
