import 'package:ecommerce/Models/add_to_cart_model.dart';
import 'package:flutter/material.dart';

class CounterWidget extends StatelessWidget {
  final int value;
  final String productId;
  final AddToCartModel? cartItem;
  final dynamic cubit;

  const CounterWidget({
    super.key,
    required this.value,
    required this.productId,
    this.cartItem,
    required this.cubit,
  });

  Future<void> incrementCounter() async {
    if (cartItem != null) {
      await cubit.incrementCounter(cartItem!, productId);
    } else {
      cubit.incrementCounter(productId);
    }
  }

  Future<void> decrementCounter() async {
    if (cartItem != null) {
      // Cart/Orders page - pass both cartItem and productId
      await cubit.decrementCounter(cartItem!, productId);
    } else {
      // Product details page - pass only productId (NO await, NO cartItem)
      cubit.decrementCounter(productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget iconNavbar(String path) {
      return Image.asset(
        path,
        height: 30,
        width: 30,
        color: Theme.of(context).primaryColor,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDF8E9),
        borderRadius: BorderRadius.circular(65),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          children: [
            InkWell(
              onTap: decrementCounter,
              child: iconNavbar('assets/icons/minus.png'),
            ),
            const SizedBox(width: 10),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 32,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: incrementCounter,
              child: iconNavbar('assets/icons/plus.png'),
            ),
          ],
        ),
      ),
    );
  }
}
