import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? userName;
int userTokens = 0;
String? uid;


setData()async{
  final prefs = await SharedPreferences.getInstance();

  uid = prefs.getString('uid');

}

buyStocks() async {
  int stockAmount = 0;
  int stockPrice = 0;
  int totalAmount = stockPrice * stockAmount;
  if(totalAmount < userTokens){
    userTokens = (userTokens - totalAmount);
    await FirebaseFirestore.instance.collection('users').doc(uid).update({'tokens': userTokens});
  }
  else{

  }
}

sellStocks() async {
  int stockAmount = 0;
  int stockPrice = 0;
  int totalAmount = stockPrice * stockAmount;
  if(totalAmount != 0){
    userTokens = (userTokens + totalAmount);
    await FirebaseFirestore.instance.collection('users').doc(uid).update({'tokens': userTokens});
  }
  else{

  }
}