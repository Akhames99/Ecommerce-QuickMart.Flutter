// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product': product.toMap(),
      'size': size.name,
      'quantity': quantity,
    };
  }

  factory AddToCartModel.fromMap(Map<String, dynamic> map) {
    return AddToCartModel(
      id: map['id'] as String,
      product: ProductItemModel.fromMap(map['product']),
      size: productSize.fromString(map['size']),
      quantity: map['quantity'] as int,
    );
  }

  AddToCartModel copyWith({
    String? id,
    ProductItemModel? product,
    productSize? size,
    int? quantity,
  }) {
    return AddToCartModel(
      id: id ?? this.id,
      product: product ?? this.product,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }
}

List<AddToCartModel> theCart = [];
