import 'package:ecommerce/Models/added_card_model.dart';
import 'package:ecommerce/Models/location_item_model.dart';
import 'package:ecommerce/Utils/app_routes.dart';
import 'package:ecommerce/View_Models/checkout_cubit/checkout_cubit.dart';
import 'package:ecommerce/View_Models/payment_methods_cubit/Payment_methods_cubit.dart';
import 'package:ecommerce/Views/Widgets/checkout_headlines.dart';
import 'package:ecommerce/Views/Widgets/payment_method_bottom_sheet.dart';
import 'package:ecommerce/Views/Widgets/payment_method_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget IconNavbar(String path, Color color) {
      return Image.asset(path, height: 30, width: 30, color: color);
    }

    Widget _buildPaymentMethodItem(
      AddedCardModel? chosenCard,
      CheckoutCubit checkoutCubit,
      BuildContext context,
    ) {
      if (chosenCard != null) {
        return PaymentMethodItem(
          paymentCard: chosenCard,
          onButtonTapped: () {
            showModalBottomSheet(
              context: context,
              builder: (_) {
                return SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: BlocProvider(
                    create: (context) {
                      final cubit = PaymentMethodsCubit();
                      cubit.fetchPaymentMethods();
                      return cubit;
                    },
                    child: const PaymentMethodBottomSheet(),
                  ),
                );
              },
            ).then((value) {
              checkoutCubit.getCartItems();
            });
          },
        );
      } else {
        return Container(
          height: 75,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0XFFEDF8E9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Add Payment Method',
                style: TextStyle(fontSize: 20, color: Color(0XFF41AB5D)),
              ),
              const SizedBox(width: 5),
              IconNavbar('assets/icons/plus.png', const Color(0XFF41AB5D)),
            ],
          ),
        );
      }
    }

    Widget _buildShippingItem(
      LocationItemModel? chosenLocation,
      BuildContext context,
    ) {
      if (chosenLocation != null) {
        return Row(
          children: [
            Image.asset(
              chosenLocation.locationImg,
              width: 140,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chosenLocation.city),
                SizedBox(height: 10),
                Text(chosenLocation.country),
              ],
            ),
          ],
        );
      } else {
        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.chooseLocationRoute);
          },
          child: Container(
            height: 75,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0XFFEDF8E9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Add Your Address',
                  style: TextStyle(fontSize: 20, color: Color(0XFF41AB5D)),
                ),
                const SizedBox(width: 5),
                IconNavbar('assets/icons/plus.png', const Color(0XFF41AB5D)),
              ],
            ),
          ),
        );
      }
    }

    return BlocProvider(
      create: (context) {
        final cubit = CheckoutCubit();
        cubit.getCartItems();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Spacer(),
              Text(
                'CheckOut',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 18, right: 18, left: 18),
            child: Builder(
              builder: (context) {
                final checkoutCubit = BlocProvider.of<CheckoutCubit>(context);

                return BlocBuilder<CheckoutCubit, CheckoutState>(
                  bloc: checkoutCubit,
                  buildWhen: (previous, current) =>
                      current is CheckoutLoaded || current is CheckoutError,
                  builder: (context, state) {
                    if (state is CheckoutLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is CheckoutError) {
                      return Center(child: Text(state.message));
                    } else if (state is CheckoutLoaded) {
                      final cartitems = state.cartItems;
                      final chosenPaymentCard = state.chosenPaymentCard;
                      final chosenLocation = state.chosenLocation;

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            CheckoutHeadlines(
                              title: 'Address',
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.chooseLocationRoute)
                                    .then(
                                      (onValue) => checkoutCubit.getCartItems(),
                                    );
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildShippingItem(chosenLocation, context),
                            const SizedBox(height: 10),
                            CheckoutHeadlines(
                              title: 'NumberOfProducts',
                              numberOfItems: state.numOfProducts,
                            ),
                            const SizedBox(height: 10),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cartitems.length,
                              separatorBuilder: (context, index) {
                                return Divider(
                                  color: Theme.of(context).primaryColor,
                                );
                              },
                              itemBuilder: (context, index) {
                                final cartItem = cartitems[index];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 18.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                            ),
                                            height: 85,
                                            width: 85,
                                            child: Image.asset(
                                              cartItem.product.imgPath,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cartItem.product.name,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColor,
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
                                                        color: Theme.of(
                                                          context,
                                                        ).primaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                            text:
                                                (cartItem.product.price *
                                                        cartItem.quantity)
                                                    .toStringAsFixed(2),
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                            ),
                                          ),
                                        ],
                                        style: const TextStyle(
                                          fontSize: 40,
                                          color: Color(0XFF41AB5D),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            CheckoutHeadlines(title: 'Payment'),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.addNewCardRoute)
                                    .then(
                                      (value) => checkoutCubit.getCartItems(),
                                    );
                              },
                              child: _buildPaymentMethodItem(
                                chosenPaymentCard,
                                checkoutCubit,
                                context,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Divider(color: Theme.of(context).primaryColor),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'TotalAmount: ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: '\$ ',
                                    children: [
                                      TextSpan(
                                        text: (state.totalAmount)
                                            .toStringAsFixed(2),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Color(0XFF41AB5D),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 44,
                              width: 225,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: const Color(0XFFEDF8E9),
                                  backgroundColor: const Color(0XFF41AB5D),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Proceed To Payment',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: Text('Something Went Wrong'));
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
