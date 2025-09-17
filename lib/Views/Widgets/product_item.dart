import 'package:ecommerce/Models/product_item_model.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final ProductItemModel productItem;
  const ProductItem({super.key, required this.productItem});

  @override
  Widget build(BuildContext context) {
    Widget IconNavbar(String path) {
      return Image.asset(path, height: 10, width: 10, color: Colors.white);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 140,
              width: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0XFFEDF8E9),
              ),
              child: Image.asset(productItem.imgPath),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0XFF005A32),
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 30,
                width: 30,
                child: IconNavbar('assets/icons/favoriteO.png'),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          productItem.name,
          style: TextStyle(fontSize: 24, color: Color(0xFF005A32)),
        ),
        SizedBox(height: 10),
        Text(
          productItem.brand,
          style: TextStyle(fontSize: 16, color: Color(0xFF41AB5D)),
        ),
        SizedBox(height: 10),
        Text(
          '\$ ${productItem.price}',
          style: TextStyle(fontSize: 24, color: Color(0xFF005A32)),
        ),
      ],
    );
  }
}
