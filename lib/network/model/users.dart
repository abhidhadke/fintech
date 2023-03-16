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
  try{
    var data = await FirebaseFirestore.instance
        .collection('company')
        .doc(stockName)
        .get();
    int initialStockAmount = data.data()!['stock'];
    if (initialStockAmount != 0) {
      int stockAmount = amount;
      int stockPrice = price;
      int totalAmount = stockPrice * stockAmount;
      int newStockAmount = initialStockAmount - stockAmount;
      if (initialStockAmount > newStockAmount) {
        if (totalAmount < userTokens) {
          userTokens = (userTokens - totalAmount);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({'tokens': userTokens});
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .set({stockName: stockAmount});
          await FirebaseFirestore.instance
              .collection('company')
              .doc(stockName)
              .update({'stock': newStockAmount});
        } else {}
      } else {}
    }
  }catch(e){
    debugPrint('$e');
  }
}

sellStocks(String stockName, int amount, int price) async {
  try{
    var data = await FirebaseFirestore.instance
        .collection('company')
        .doc(stockName)
        .get();
    var stock = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    int userStock = stock.data()![stockName];
    int initialStockAmount = data.data()!['stock'];
    int stockAmount = amount;
    int stockPrice = price;
    int totalAmount = stockPrice * stockAmount;
    int newStockAmount = initialStockAmount + stockAmount;
    if (totalAmount != 0 && userStock >= stockAmount) {
      userTokens = (userTokens + totalAmount);
      await FirebaseFirestore.instance
          .collection('company')
          .doc(stockName)
          .update({'stock': newStockAmount});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({stockName: stockAmount});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'tokens': userTokens});
    } else {}
  }catch(e){
    debugPrint('$e');
  }
}
