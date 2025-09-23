import 'package:flutter/material.dart';

Widget TotalAndSubtotalWidget(
  context, {
  required String title,
  required double amount,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        '${title}:',
        style: TextStyle(fontSize: 32, color: Color(0XFFEDF8E9)),
      ),
      Text.rich(
        TextSpan(
          text: '\$ ',
          children: [
            TextSpan(
              text: amount.toStringAsFixed(2),
              style: TextStyle(fontSize: 40, color: Color(0XFFEDF8E9)),
            ),
          ],
          style: TextStyle(fontSize: 40, color: Color(0XFF41AB5D)),
        ),
      ),
    ],
  );
}
