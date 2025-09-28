import 'package:ecommerce/Utils/app_routes.dart';
import 'package:ecommerce/View_Models/cart_cubit/cart_cubit.dart';
import 'package:ecommerce/Views/Widgets/cart_item_widget.dart';
import 'package:ecommerce/Views/Widgets/total_and_subtotal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = CartCubit();
        cubit.getCartItems();
        return cubit;
      },
      child: Builder(
        builder: (context) {
          return BlocBuilder<CartCubit, CartState>(
            bloc: BlocProvider.of<CartCubit>(context),
            buildWhen: (previous, current) =>
                current is CartLoading ||
                current is CartLoaded ||
                current is CartError,
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is CartLoaded) {
                final cartItems = state.cartItems;
                if (cartItems.isEmpty) {
                  return const Center(child: Text('Your Cart Is Empty!'));
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 68,
                        right: 18,
                        left: 18,
                      ),
                      child: Text(
                        'My Orders',
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: ListView.separated(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartItems[index];
                            return CartItemWidget(cartItem: cartItem);
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Theme.of(context).primaryColor,
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Divider(color: Theme.of(context).primaryColor),
                    ),
                    Container(
                      height: 363,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 23,
                          right: 18,
                          left: 18,
                        ),
                        child: Column(
                          children: [
                            TotalAndSubtotalWidget(
                              context,
                              title: 'SubTotal',
                              amount: state.subTotal,
                            ),
                            const SizedBox(height: 18.0),
                            TotalAndSubtotalWidget(
                              context,
                              title: 'Shipping',
                              amount: 10,
                            ),
                            const SizedBox(height: 18.0),
                            Dash(
                              dashColor: const Color(0XFFEDF8E9),
                              length: MediaQuery.of(context).size.width - 64,
                            ),
                            SizedBox(height: 18),
                            TotalAndSubtotalWidget(
                              context,
                              title: 'Total',
                              amount: state.subTotal + 10,
                            ),
                            SizedBox(height: 30),
                            SizedBox(
                              height: 44,
                              width: 197,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0XFF41AB5D),
                                  foregroundColor: Color(0XFFEDF8E9),
                                ),
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pushNamed(AppRoutes.checkOutRoute);
                                },
                                child: Text(
                                  'CheckOut',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is CartError) {
                return Center(child: Text(state.message));
              } else if (state is CartInitial) {
                return const Center(child: Text('Your Cart Is Empty!'));
              } else {
                return const Center(child: Text('Something Went Wrong'));
              }
            },
          );
        },
      ),
    );
  }
}
