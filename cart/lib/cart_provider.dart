import 'package:cart/cart_model.dart';
import 'package:cart/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  DBHelper db = DBHelper();

  int _counter = 0;
  double _totalPrice = 0.0;

  int get counter => _counter;
  double get totalPrice => _totalPrice;

  CartProvider() {
    _getPrefItems(); // ✅ LOAD DATA ON START
  }

  Future<List<Cart>> getData() async {
    return db.getCartList();
  }

  void _setPrefItems() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
  }

  void _getPrefItems() async {
    final prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    notifyListeners(); // ✅ IMPORTANT
  }

  void addTotalPrice(double price) {
    _totalPrice += price;
    _setPrefItems();
    notifyListeners();
  }

  void addCounter() {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  int getCounter() => _counter;
}