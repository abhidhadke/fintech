import 'package:fintech/constants.dart';
import 'package:fintech/screens/Homepage/hompage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '', password = '', uid = '';
  bool passFill = true;
  bool emailFill = true;
  bool isLoading = false;
  bool wrongPass = false;
  String errorMsg = '';
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: bgSecondary,
        body: Stack(
          children: [
            Center(
              child: Image.asset('assets/cf_logo.png', color: Colors.green.withOpacity(0.2),),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.1,
                  ),
                  Image.asset('assets/logo.png'),
                  Formfield(
                    size: constraints,
                    text: 'email',
                    isPassword: false,
                    onChanged: (String val) {
                      email = val;
                    },
                    isFilled: emailFill,
                  ),
                  Formfield(
                    size: constraints,
                    text: 'password',
                    isPassword: true,
                    onChanged: (String val) {
                      password = val;
                    },
                    isFilled: passFill,
                  ),
                  Visibility(
                    visible: wrongPass,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.01,
                          ),
                          Text(
                            errorMsg,
                            style: GoogleFonts.poppins(
                                color: Colors.redAccent,
                                fontStyle: FontStyle.italic),
                          )
                        ]
                            .map((e) => Padding(
                                  padding: EdgeInsets.only(
                                      left: constraints.maxWidth * 0.09),
                                  child: e,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),
                  ElevatedButtonTheme(
                    data: ElevatedButtonThemeData(
                        style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(GoogleFonts.poppins(
                          fontSize: constraints.maxWidth * 0.07,
                          fontWeight: FontWeight.w600)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 8)),
                      elevation: MaterialStateProperty.all(10),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                      fixedSize: MaterialStateProperty.all(Size(
                          constraints.maxWidth * 0.7,
                          constraints.maxHeight * 0.07)),
                    )),
                    child: ElevatedButton(
                      onPressed: () async {
                        debugPrint('tapped');
                        if (email == '') {
                          if (password == '') {
                            setState(() {
                              emailFill = false;
                              passFill = false;
                            });
                          } else {
                            setState(() {
                              emailFill = false;
                            });
                          }
                        } else if (password == '') {
                          if (email == '') {
                            setState(() {
                              emailFill = false;
                              passFill = false;
                            });
                          } else {
                            setState(() {
                              passFill = false;
                            });
                          }
                        } else {
                          setState(() {
                            isLoading = true;
                            passFill = true;
                            emailFill = true;
                          });

                          // firebase login code goes here
                          try {
                            final user = await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            final userData = user.user;
                            if (userData != null) {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('login', true);
                              uid = userData.uid;
                              await prefs.setString('uid', uid);
                              debugPrint(uid);
                              await _pushtoNextScreen();
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          } on FirebaseAuthException catch (e) {
                            debugPrint('$e');
                            if (e.code == 'user-not-found') {
                              errorMsg = '* No user found for that email';
                            } else if (e.code == 'wrong-password') {
                              errorMsg = '* Wrong password provided for that user';
                            } else if (e.code == 'invalid-email') {
                              errorMsg = '* The email address is invalid';
                            }
                            else if(e.code == 'too-many-requests'){
                              errorMsg = '* Too many requests, try again later';
                            }
                            setState(() {
                              wrongPass = true;
                              isLoading = false;
                            });
                          }
                          //end of code
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              'Login',
                              style: GoogleFonts.poppins(),
                            ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: constraints.maxWidth * 0.4,child: Image.asset('assets/cascode_Logo.png')),
                      SizedBox(width: constraints.maxWidth * 0.4,child: Image.asset('assets/josh_logo.png'))
                    ]
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                              child: e,
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.1,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  _pushtoNextScreen() async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => Homepage(
                  uid: uid,
                )));
  }
}
