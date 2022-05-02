class CartModel
{
  late final int? id;
  late final String? productId;
  late final String? productName;
  late final int? initialPrice;
  late final int? productPrice;
  late final int? quantity;
  late final String? unitTag;
  late final String? image;

  CartModel({required this.id, required this.productId, required this.productName, required this.initialPrice, required this.productPrice, required this.quantity, required this.unitTag, required this.image});

  CartModel.fromMap(Map<String, dynamic> map)
  {
    id = map['id'];
    productId = map['productId'];
    productName = map['productName'];
    initialPrice = map['initialPrice'];
    productPrice = map['productPrice'];
    quantity = map['quantity'];
    unitTag = map['unitTag'];
    image = map['image'];
  }

  Map<String, dynamic> toMap()
  {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['id'] = id;
    map['productId'] = productId;
    map['productName'] = productName;
    map['initialPrice'] = initialPrice;
    map['productPrice'] = productPrice;
    map['quantity'] = quantity;
    map['unitTag'] = unitTag;
    map['image'] = image;

    return map;
  }
}