import 'package:flutter/material.dart';
import 'package:flutter_provider_shoppingcart/product_list.dart';
import 'package:flutter_provider_shoppingcart/utils/cart_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartProvider>(
      create: (context) => CartProvider(),
      builder: (context, child) => MaterialApp(
        title: 'Provider Shopping Cart',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ProductListPage(),
      ),
    );
  }
}