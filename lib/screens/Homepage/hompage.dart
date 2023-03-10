import 'package:fintech/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
            backgroundColor: bgSecondary,
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
                            color: secondary,
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
                            Text(
                              '20000 fs',
                              style: TextStyle(
                                fontSize: constraint.maxWidth * 0.075,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                      children: [
                        Container(
                          width: constraint.maxWidth,
                          height: constraint.maxHeight * 0.2,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context2, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: constraint.maxWidth * 0.05),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.pink,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          30.0,
                                        ),
                                      ),
                                    ),
                                    width: constraint.maxWidth * 0.7,
                                  ),
                                );
                              }),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              constraint.maxWidth * 0.05,
                              constraint.maxWidth * 0.1,
                              constraint.maxWidth * 0.05,
                              0.0),
                          child: Container(
                            decoration: const BoxDecoration(

                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                )),
                            width: constraint.maxWidth,
                            height: constraint.maxHeight*0.4,
                            child: ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context3, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.pink,
                                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                                      ),
                                      width: constraint.maxWidth * 0.8,
                                      height: constraint.maxHeight*0.15,
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
