import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/network/notification_helper.dart';
import 'package:fintech/screens/Homepage/hompage.dart';
import 'package:fintech/screens/Login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network/model/users.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point')
Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('${message.notification?.title}\n${message.notification?.body}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  try{
    final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
    await HelperNotification.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }catch(e){
    debugPrint('$e');
  }


  final prefs = await SharedPreferences.getInstance();
  bool login = prefs.getBool('login') ?? false;
  String uid = prefs.getString('uid') ?? '';
  debugPrint('Is user Logged in? : $login');
  await getUserDetails();

  runApp(MyApp(isLoggedIn: login, uid: uid,));
}

getUserDetails() async {
  await setData();
  final db = FirebaseFirestore.instance;
  final data = await db.collection('users').doc(uid).get();
  userName = data.data()!['username'];
  userTokens = data.data()!['tokens'];

  //debugPrint(UserTokens);
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String uid;
  const MyApp({super.key, required this.isLoggedIn, required this.uid});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
       home: isLoggedIn ?  Homepage(uid: uid,) : const LoginScreen(),
       //home: const LoginScreen(),
    );
  }
}

