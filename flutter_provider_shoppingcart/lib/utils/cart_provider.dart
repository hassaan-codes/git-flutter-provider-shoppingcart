import 'package:flutter/cupertino.dart';
import 'package:flutter_provider_shoppingcart/utils/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_model.dart';

class CartProvider with ChangeNotifier
{
  DatabaseHelper dbHelper = DatabaseHelper();

  final String CART_ITEM_COUNT_KEY = 'CartItemCount';
  final String TOTAL_PRICE_KEY = 'TotalPrice';

  int _cartItemCount = 0;
  double _totalPrice = 0.0;

  late Future<List<CartModel>> cartModelList;

  Future<List<CartModel>> getItemData() async
  {
    return dbHelper.fetch();
  }

  void setItemsPrefs() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(CART_ITEM_COUNT_KEY, _cartItemCount);
    prefs.setDouble(TOTAL_PRICE_KEY, _totalPrice);

    notifyListeners();
  }

  void getItemsPrefs() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cartItemCount = prefs.getInt(CART_ITEM_COUNT_KEY) ?? 0;
    _totalPrice = prefs.getDouble(TOTAL_PRICE_KEY) ?? 0.0;

    notifyListeners();
  }

  void addItem(double price)
  {
    _cartItemCount++;
    _totalPrice += price;
    setItemsPrefs();

    notifyListeners();
  }

  void removeItem(double price)
  {
    _cartItemCount--;
    _totalPrice -= price;
    if(_cartItemCount < 0)
    {
      _cartItemCount = 0;
      _totalPrice = 0;
    }
    setItemsPrefs();
  }

  void increaseTotalPrice(double price)
  {
    _totalPrice += price;
    setItemsPrefs();
  }

  void decreaseTotalPrice(double price)
  {
    _totalPrice -= price;
    setItemsPrefs();
  }

  int getItemCount()
  {
    getItemsPrefs();
    return _cartItemCount;
  }

  double getTotalPrice()
  {
    getItemsPrefs();
    return _totalPrice;
  }
}