import 'package:ecommerce/Models/added_card_model.dart';
import 'package:flutter/material.dart';

class PaymentMethodItem extends StatelessWidget {
  final AddedCardModel paymentCard;
  final VoidCallback onButtonTapped;
  const PaymentMethodItem({
    super.key,
    required this.paymentCard,
    required this.onButtonTapped,
  });

  @override
  Widget build(BuildContext context) {
    Widget IconNavbar(String path) {
      return Image.asset(
        path,
        height: 20,
        width: 20,
        color: Theme.of(context).primaryColor,
      );
    }

    return InkWell(
      onTap: onButtonTapped,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 70,
            width: 105,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/images/masterCard.png'),
            ),
          ),
          SizedBox(
            height: 70,
            width: 232,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0XFFEDF8E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Master Card',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          paymentCard.cardNumber,
                          style: TextStyle(color: Color(0XFF41AB5D)),
                        ),
                      ],
                    ),
                    IconNavbar('assets/icons/chevronRight.png'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
