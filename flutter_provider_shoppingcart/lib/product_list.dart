import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_shoppingcart/cart_screen.dart';
import 'package:flutter_provider_shoppingcart/models/cart_model.dart';
import 'package:flutter_provider_shoppingcart/utils/cart_provider.dart';
import 'package:flutter_provider_shoppingcart/utils/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductListPage extends StatelessWidget {

  DatabaseHelper dbHelper = DatabaseHelper();

  List<String> productName = ['Product 1' , 'Product 2' , 'Product 3' , 'Product 4' , 'Product 5' , 'Product 7','Product 8',] ;
  List<String> productUnit = ['ETH' , 'ETH' , 'BTC' , 'ETH' , 'ETH' , 'ETH','ETH',] ;
  List<int> productPrice = [200, 250 , 300 , 250 , 400, 200 , 500 ] ;
  List<String> productImage = [
    'https://lh3.googleusercontent.com/8YS0EYVsF2e6DcYYXJLUbKI7WJcK7WuOSUZymdWuqXTQa5igQiNPTF9tMUhnv9aM_51GEPnPFvPyut5nS7JzNztxjQdpyaRfOOPyfg=w600',
    'https://media.mutualart.com/Images/2021_09/17/16/162503295/0121b69c-2837-48a2-9717-c86e1d786c42_570.Jpeg',
    'https://nftexplained.info/wp-content/uploads/2021/08/Untitled-design-44.png',
    'https://nftexplained.info/wp-content/uploads/2021/08/Untitled-design-44.png',
    'https://variety.com/wp-content/uploads/2021/10/Guy-oseary-ape.jpg?w=681&h=383&crop=1&resize=681%2C383',
    'https://preview.redd.it/uy0ryg3uaag81.jpg?width=631&format=pjpg&auto=webp&s=8946b5bc12c4a41284bb0d063108c63c97d6df6f',
    'https://nftexplained.info/wp-content/uploads/2021/08/Untitled-design-44.png',
  ];

  ProductListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        title: Text('Products'),
        centerTitle: true,

        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(value.getItemCount().toString(), style: TextStyle(color: Colors.white));
                  },
                ),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),


          SizedBox(width: 20.0,),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productName.length,
              itemBuilder: (context, index) => ProductTileWidget(context, index),
            ),
          ),
        ],
      ),
    );
  }

  Widget ProductTileWidget(BuildContext context, int index)
  {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                width: 100,
                height: 100,
                image: NetworkImage(productImage[index]),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName[index],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 5,),

                    Row(
                      children: [
                        SizedBox(width: 3,),

                        Text(
                          productUnit[index],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(width: 5,),

                        Text(
                          "${productPrice[index].toString()}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 25,
                        child: ElevatedButton(
                          onPressed: (){
                            CartModel cartModel = CartModel(
                              id: index,
                              productId: index.toString(),
                              productName: productName[index],
                              initialPrice: productPrice[index],
                              productPrice: productPrice[index],
                              quantity: 1,
                              unitTag: productUnit[index],
                              image: productImage[index],
                            );
                            dbHelper.insert(cartModel)
                              .then((value) {
                                print('added to cart successfully!');
                                cartProvider.addItem(double.parse(productPrice[index].toString()));
                              })
                              .onError((error, stackTrace) {
                                print('failed to add to cart!');
                            });
                          },
                          child: Text('Add to cart'),
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            primary: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
