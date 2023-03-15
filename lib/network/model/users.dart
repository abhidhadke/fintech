import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var UserName;
var UserTokens;
var uid;

final db = FirebaseFirestore.instance;
final data = db.collection('users').doc('$uid').get();

// getUserDetails() async {
//   final db = FirebaseFirestore.instance;
//   final data = await db.collection('users').doc(uid).get();
//   UserName = data.data()!['username'];
//   UserTokens = data.data()!['tokens'];
// }