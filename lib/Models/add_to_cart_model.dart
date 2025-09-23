import 'package:ecommerce/Models/product_item_model.dart';

class AddToCartModel {
  final String id;
  final ProductItemModel product;
  final productSize size;
  int quantity;

  AddToCartModel({
    required this.id,
    required this.product,
    required this.size,
    this.quantity = 1,
  });
}

List<AddToCartModel> theCart = [];
