import 'package:cloud_firestore/cloud_firestore.dart';

String userName = '';

userData(String uid) async {
  final userId = FirebaseFirestore.instance.collection('users').doc(uid);
}

