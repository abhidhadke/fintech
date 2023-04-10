import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? userName;
int userTokens = 0;
String? uid;
late Stream<QuerySnapshot<Map<String, dynamic>>> newsStream;
late Stream<QuerySnapshot<Map<String, dynamic>>> stocksStream;
late Stream<DocumentSnapshot<Map<String, dynamic>>> userData;

List<QueryDocumentSnapshot<Map<String, dynamic>>> ?stockData = [];

setData() async {
  try{
    final prefs = await SharedPreferences.getInstance();
    final db = FirebaseFirestore.instance;
    uid = prefs.getString('uid');
    newsStream = db
        .collection('news_alerts')
        .orderBy('news_time', descending: true)
        .snapshots();
    stocksStream = db
        .collection('company')
        .snapshots();
    userData = db.collection('users').doc(uid).snapshots();
  }catch(e){
    debugPrint('$e');
  }
}

buyStocks(String stockName, int amount, int price) async {
  try {
    debugPrint('$stockName $amount $price');
    String myString = stockName;
    myString = myString.trimLeft();
    var data = await FirebaseFirestore.instance
        .collection('company')
        .doc(myString)
        .get();
    var stock =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    debugPrint('${data.exists}');
    int userStock = stock.data()?[stockName] ?? 0;
    int initialStockAmount = data.data()!['stock'];
    debugPrint(initialStockAmount.toString());
    //if (initialStockAmount != 0) {
    int stockAmount = amount;
    //int finalStockAmount = (if) stockAmount + ;
    int stockPrice = price;
    int totalAmount = stockPrice * stockAmount;
    int newStockAmount = initialStockAmount - stockAmount;
    debugPrint('$initialStockAmount $totalAmount $newStockAmount');
    if (initialStockAmount > newStockAmount) {
      if (totalAmount < userTokens) {
        userTokens = (userTokens - totalAmount);
        userStock = userStock + stockAmount;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'tokens': userTokens, stockName: userStock});
        await FirebaseFirestore.instance
            .collection('company')
            .doc(myString)
            .update({'stock': newStockAmount});
      } else {}
    } else {}
    return 1;
  } catch (e, s) {
    debugPrint('$e, \n $s');
    return 0;
  }
}

sellStocks(String stockName, int amount, int price) async {
  try {
    debugPrint('$stockName $amount $price');
    String myString = stockName;
    myString = myString.trimLeft();
    var data = await FirebaseFirestore.instance
        .collection('company')
        .doc(myString)
        .get();
    var stock =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    int userStock = stock.data()![stockName];
    int initialStockAmount = data.data()!['stock'];
    int stockPrice = price;
    int totalAmount = stockPrice * amount;
    int newStockAmount = initialStockAmount + amount;
    if (totalAmount != 0 && userStock >= amount) {
      userTokens = (userTokens + totalAmount);
      userStock = userStock - amount;
      await FirebaseFirestore.instance
          .collection('company')
          .doc(myString)
          .update({'stock': newStockAmount});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({stockName: userStock, 'tokens': userTokens});
    } else {}
    return 1;
  } catch (e) {
    debugPrint('$e');
    return 0;
  }
}

checkCount(String stockName) async {
  var data =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  int maxStocks = data.data()![stockName];
  return maxStocks;
}
