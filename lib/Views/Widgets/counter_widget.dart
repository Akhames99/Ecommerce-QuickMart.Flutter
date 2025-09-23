import 'package:flutter/material.dart';

class CounterWidget extends StatelessWidget {
  final int value;
  final String productId;
  final dynamic cubit;
  final int? initialValue;
  const CounterWidget({
    super.key,
    required this.value,
    required this.productId,
    required this.cubit,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    Widget IconNavbar(String path) {
      return Image.asset(
        path,
        height: 30,
        width: 30,
        color: Theme.of(context).primaryColor,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFEDF8E9),
        borderRadius: BorderRadius.circular(65),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Row(
          children: [
            InkWell(
              onTap: () => initialValue != null
                  ? cubit.decrementCounter(productId, initialValue)
                  : cubit.decrementCounter(productId),
              child: IconNavbar('assets/icons/minus.png'),
            ),
            SizedBox(width: 10),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 32,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () => initialValue != null
                  ? cubit.incrementCounter(productId, initialValue)
                  : cubit.incrementCounter(productId),
              child: IconNavbar('assets/icons/plus.png'),
            ),
          ],
        ),
      ),
    );
  }
}
