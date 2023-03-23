import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? userName;
int userTokens = 0;
String? uid;

setData() async {
  final prefs = await SharedPreferences.getInstance();
  uid = prefs.getString('uid');
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

    int userStock = stock.data()?[stockName] ?? 0;
    int initialStockAmount = data.data()!['stock'];
    int stockAmount = amount;
    int stockPrice = price;
    int totalAmount = stockPrice * stockAmount;
    int newStockAmount = initialStockAmount - stockAmount;

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
