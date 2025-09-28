import 'package:flutter/material.dart';

class CheckoutHeadlines extends StatelessWidget {
  final String title;
  final int? numberOfItems;
  final VoidCallback? onTap;
  const CheckoutHeadlines({
    super.key,
    required this.title,
    this.numberOfItems,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            if (numberOfItems != null)
              Text(
                '($numberOfItems)',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
          ],
        ),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: Text(
              'Edit',
              style: TextStyle(fontSize: 20, color: Color(0XFF41AB5D)),
            ),
          ),
      ],
    );
  }
}
