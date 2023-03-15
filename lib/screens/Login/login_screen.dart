import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/constants.dart';
import 'package:fintech/screens/Homepage/hompage.dart';
import 'package:fintech/screens/News/News_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/textfield.dart';
import '../../network/model/users.dart' as cUser;

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
  final _auth = FirebaseAuth.instance;
  String uid = '';

  dynamic usser;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: bgSecondary,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: constraints.maxHeight*0.1,),
              Image.asset('assets/logo.png'),
              SizedBox(height: constraints.maxHeight * 0.1,),
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
              SizedBox(height: constraints.maxHeight * 0.05,),
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
                  onPressed: () async {
                    //await _pushtoNextScreen();
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
                      try{
                        final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                        final userData = user.user;
                        if(userData != null){
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('login', true);
                          uid = userData.uid;
                          await prefs.setString('uid', uid);
                          //debugPrint('$Uname');
                          debugPrint(uid);
                          await _pushtoNextScreen();
                        }
                        else{
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                      catch(e){
                        debugPrint('$e');
                        setState(() {
                          isLoading = false;
                        });
                      }
                      //end of code
                    }

                  },
                  child: isLoading ? const CircularProgressIndicator() : Text('Login', style: GoogleFonts.poppins(),),
                ),
              ),
              SizedBox(height: constraints.maxHeight*0.1,),
            ],
          ),
        ),
      );
    });
  }

  _pushtoNextScreen() async {
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>  Homepage(uid: uid,)));

  }
}
