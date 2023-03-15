import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

var UserName;
var UserTokens;
var uid;

setData()async{
  final prefs = await SharedPreferences.getInstance();

  uid = prefs.getString('uid');

  final db = FirebaseFirestore.instance;
  final data = db.collection('users').doc('$uid').get();

}
// getUserDetails() async {
//   final db = FirebaseFirestore.instance;
//   final data = await db.collection('users').doc(uid).get();
//   UserName = data.data()!['username'];
//   UserTokens = data.data()!['tokens'];
// }