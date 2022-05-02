import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_shoppingcart/utils/cart_provider.dart';
import 'package:flutter_provider_shoppingcart/utils/db_helper.dart';
import 'package:provider/provider.dart';

import 'models/cart_model.dart';

class CartScreen extends StatelessWidget {
  DatabaseHelper dbHelper = DatabaseHelper();

  CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        title: Text('My Cart'),
        centerTitle: true,

        actions: [
          Center(
            child: Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(value.getItemCount().toString(), style: TextStyle(color: Colors.white));
                },
              ),
              child: Icon(Icons.shopping_bag_outlined),
            ),
          ),
          SizedBox(width: 20.0,),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: cartProvider.getItemData(),
            builder: (context, AsyncSnapshot<List<CartModel>> snapshot) {
              if(snapshot.hasData)
              {
                if(snapshot.data!.isEmpty)
                {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(Icons.work_off_outlined, size: 100, color: Colors.grey[500],)
                        ),
                        SizedBox(height: 20,),
                        Container(
                          child: Text("Cart is empty!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[500]),),
                        )
                      ],
                    ),
                  );
                }
                else
                {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => ProductTileWidget(context, snapshot, index),
                    ),
                  );
                }
              }
              else
              {
                print('failed to fetch');
                return Container();
              }
            },
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Consumer<CartProvider>(
                  builder:(context, value, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Price ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      Text('ETH ${value.getTotalPrice().toString()}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget ProductTileWidget(BuildContext context, AsyncSnapshot<List<CartModel>> snapshot, int index)
  {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    return Card(
      margin: EdgeInsets.all(10),
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
                image: NetworkImage(snapshot.data![index].image.toString()),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          snapshot.data![index].productName.toString(),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(right: 20, top: 0),
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  int quantity = snapshot.data![index].quantity!;
                                  if(quantity <= 1) return;

                                  quantity--;

                                  int newPrice = snapshot.data![index].initialPrice! * quantity;

                                  dbHelper.updateCart(
                                    CartModel(
                                      id: snapshot.data![index].id,
                                      productId: snapshot.data![index].productId,
                                      productName: snapshot.data![index].productName,
                                      initialPrice: snapshot.data![index].initialPrice,
                                      productPrice: newPrice,
                                      quantity: quantity,
                                      unitTag: snapshot.data![index].unitTag,
                                      image: snapshot.data![index].image
                                    )
                                  ).then((value) => cartProvider.decreaseTotalPrice(double.parse(snapshot.data![index].initialPrice.toString())));
                                },
                                child: Icon(Icons.remove)
                              ),
                              Container(
                                child: Text('${snapshot.data![index].quantity.toString()}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[700]),),
                              ),
                              InkWell(
                                onTap: () {
                                  int quantity = snapshot.data![index].quantity!;
                                  quantity++;
                                  int newPrice = snapshot.data![index].initialPrice! * quantity;

                                  dbHelper.updateCart(
                                      CartModel(
                                        id: snapshot.data![index].id,
                                        productId: snapshot.data![index].productId,
                                        productName: snapshot.data![index].productName,
                                        initialPrice: snapshot.data![index].initialPrice,
                                        productPrice: newPrice,
                                        quantity: quantity,
                                        unitTag: snapshot.data![index].unitTag,
                                        image: snapshot.data![index].image,
                                      )
                                  ).then((value) => cartProvider.increaseTotalPrice(double.parse(snapshot.data![index].initialPrice.toString())));
                                },
                                child: Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        SizedBox(width: 3,),

                        Text(
                          snapshot.data![index].unitTag.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(width: 5,),

                        Text(
                          "${snapshot.data![index].initialPrice.toString()}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 7, bottom: 7, right: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text('ETH ${(snapshot.data![index].quantity! * snapshot.data![index].initialPrice!).toString()}', style: TextStyle(fontSize: 16, color: Colors.grey[700]),),
                            ),
                          ),

                          Container(
                            //margin: EdgeInsets.only(right: 20, bottom: 10),
                            height: 25,
                            child: ElevatedButton(
                              onPressed: (){
                                dbHelper.deleteProduct(snapshot.data![index].id!);
                                cartProvider.removeItem(double.parse(snapshot.data![index].productPrice.toString()));
                              },
                              child: Text('Remove'),
                              style: ElevatedButton.styleFrom(
                                alignment: Alignment.center,
                                primary: Colors.red[600],
                              ),
                            ),
                          ),
                        ],
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
