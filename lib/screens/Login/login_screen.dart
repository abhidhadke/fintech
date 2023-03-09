import 'package:fintech/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'components/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '', password = '';
  bool passFill = true;
  bool emailFill = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: bgNight,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * 0.25,
                      child: Image.asset('assets/logo.png'),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02,),
                    formField(
                      size: constraints,
                      text: 'email',
                      isPassword: false,
                      onChanged: (String val) {
                        email = val;
                      },
                      isFilled: emailFill,
                    ),
                    formField(
                      size: constraints,
                      text: 'password',
                      isPassword: true,
                      onChanged: (String val) {
                        password = val;
                      },
                      isFilled: passFill,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02,),
                    ElevatedButtonTheme(
                      data: ElevatedButtonThemeData(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(GoogleFonts.poppins(
                            fontSize: constraints.maxWidth * 0.07,
                            fontWeight: FontWeight.w600
                          )),
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8)),
                          elevation: MaterialStateProperty.all(10),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                          fixedSize: MaterialStateProperty.all(
                            Size(constraints.maxWidth * 0.7, constraints.maxHeight * 0.07)
                          ),

                        )
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint('tapped');
                          if(email == ''){
                            if(password == ''){
                              setState(() {
                                emailFill = false;
                                passFill = false;
                              });
                            }else{
                              setState(() {
                                emailFill = false;
                              });
                            }
                          }
                          else if(password == ''){
                            if(email == ''){
                              setState(() {
                                emailFill = false;
                                passFill = false;
                              });
                            }else{
                              setState(() {
                                passFill = false;
                              });
                            }
                          }
                          else{
                            setState(() {
                              isLoading = true;
                              passFill = true;
                              emailFill = true;
                            });

                            // firebase login code goes here

                            //end of code
                          }

                        },
                        child: isLoading ? const CircularProgressIndicator() : Text('Login', style: GoogleFonts.poppins(),),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
