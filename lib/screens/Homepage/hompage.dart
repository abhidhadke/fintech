import 'package:fintech/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Scaffold(
            extendBodyBehindAppBar: false,
            body: Column(
              children: [
                SizedBox(
                  height: constraint.maxHeight * 0.17,
                ),
                Padding(
                  padding: EdgeInsets.all(constraint.maxWidth * 0.05),
                  child: Row(
                    children: [
                      SizedBox(
                        child: Text(
                          'Welcome, \nUsername !',
                          style: TextStyle(
                            fontSize: constraint.maxWidth * 0.06,
                          ),
                        ),
                        width: constraint.maxWidth * 0.4,
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          color: btnColor,
                        ),
                        height: constraint.maxHeight * 0.1,
                        width: constraint.maxWidth * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('20000 fs', style: TextStyle(
                              fontSize: constraint.maxWidth*0.07,
                              fontWeight: FontWeight.w600,
                            ),),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    // height: constraint.maxHeight,
                    // width: constraint.maxWidth,
                    decoration: const BoxDecoration(
                      color: bgPrimary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        topLeft: Radius.circular(40.0),
                      ),
                    ),
                    child: ListView(
                      children: [],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
