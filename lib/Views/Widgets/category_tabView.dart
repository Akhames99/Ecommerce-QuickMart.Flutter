import 'package:ecommerce/Models/category_item_model.dart';
import 'package:flutter/material.dart';

class CategoryTabview extends StatelessWidget {
  const CategoryTabview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categoryItems.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            height: 167,
            width: 353,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Image.asset(
                categoryItems[index].imgPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
