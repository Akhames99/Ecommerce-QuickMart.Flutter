import 'package:ecommerce/Models/add_to_cart_model.dart';
import 'package:ecommerce/View_Models/cart_cubit/cart_cubit.dart';
import 'package:ecommerce/Views/Widgets/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemWidget extends StatelessWidget {
  final AddToCartModel cartItem;
  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CartCubit>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor,
                ),
                height: 85,
                width: 85,
                child: Image.asset(cartItem.product.imgPath),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Size: ',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0XFF41AB5D),
                      ),
                      children: [
                        TextSpan(
                          text: cartItem.size.name,
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 🔥 Listen for CartLoaded instead of CounterQuantityLoaded
                  BlocBuilder<CartCubit, CartState>(
                    buildWhen: (previous, current) {
                      if (current is CartLoaded) {
                        // Rebuild only if THIS item's quantity changed
                        final updatedItem = current.cartItems.firstWhere(
                          (item) => item.id == cartItem.id,
                          orElse: () => cartItem,
                        );
                        return updatedItem.quantity != cartItem.quantity;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      if (state is CartLoaded) {
                        final updatedItem = state.cartItems.firstWhere(
                          (item) => item.id == cartItem.id,
                          orElse: () => cartItem,
                        );

                        return CounterWidget(
                          value: updatedItem.quantity,
                          productId: cartItem.id,
                          cubit: cubit,
                        );
                      }

                      // fallback if not loaded yet
                      return CounterWidget(
                        value: cartItem.quantity,
                        productId: cartItem.id,
                        cubit: cubit,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            text: '\$ ',
            children: [
              TextSpan(
                text: '${cartItem.product.price}',
                style: TextStyle(
                  fontSize: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
            style: const TextStyle(fontSize: 40, color: Color(0XFF41AB5D)),
          ),
        ),
      ],
    );
  }
}
