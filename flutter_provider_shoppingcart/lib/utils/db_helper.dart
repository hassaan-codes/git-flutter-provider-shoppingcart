import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

import 'package:flutter_provider_shoppingcart/models/cart_model.dart';

class DatabaseHelper
{
  static Database? _database;
  String? _databaseName = 'Cart.db';

  Future<Database> get database async
  {
    if(_database != null)
    {
      return _database!;
    }
    else
    {
      _database = await initDatabase();
      return _database!;
    }
  }

  initDatabase() async
  {
    io.Directory director = await getApplicationDocumentsDirectory();
    String path = join(director.path, _databaseName);

    var database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  _onCreate(Database db, int version) async
  {
    await db.execute  (
      'CREATE TABLE cart (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productName TEXT,initialPrice INTEGER, productPrice INTEGER , quantity INTEGER, unitTag TEXT , image TEXT )'
    );
  }

  Future<CartModel> insert(CartModel cartModel) async
  {
    final dbClient = await database;
    await dbClient.insert('cart', cartModel.toMap());
    return cartModel;
  }

  Future<List<CartModel>> fetch() async
  {
    final dbClient = await database;
    final List<Map<String, dynamic>> queryResults = await dbClient.query('cart');
    return queryResults.map((e) => CartModel.fromMap(e)).toList();
  }

  deleteProduct(int id) async
  {
    final dbClient = await database;
    dbClient.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateCart(CartModel cart) async
  {
    final dbClient = await database;
    return await dbClient.update('cart', cart.toMap(), where: 'id = ?', whereArgs: [cart.id]);
  }
}