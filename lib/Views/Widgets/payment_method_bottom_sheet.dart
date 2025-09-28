import 'package:ecommerce/Utils/app_routes.dart';
import 'package:ecommerce/View_Models/payment_methods_cubit/Payment_methods_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodBottomSheet extends StatefulWidget {
  const PaymentMethodBottomSheet({super.key});

  @override
  State<PaymentMethodBottomSheet> createState() =>
      _PaymentMethodBottomSheetState();
}

class _PaymentMethodBottomSheetState extends State<PaymentMethodBottomSheet> {
  late final PaymentMethodsCubit paymentMethodCubit;

  @override
  void initState() {
    super.initState();
    paymentMethodCubit = PaymentMethodsCubit();
    paymentMethodCubit.fetchPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    Widget IconNavbar(String path, Color color) {
      return Image.asset(path, height: 30, width: 30, color: color);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Color(0XFF41AB5D),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 51,
            left: 29,
            right: 29,
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Method',
                style: TextStyle(color: Color(0XFFEDF8E9), fontSize: 24),
              ),
              BlocBuilder(
                bloc: paymentMethodCubit,
                buildWhen: (previous, current) =>
                    current is FetchingPaymentMethods ||
                    current is FetchedPaymentMethods ||
                    current is FetchingPaymentMethodsError,
                builder: (_, state) {
                  if (state is FetchingPaymentMethods) {
                    return Transform.scale(
                      scale: 0.5,
                      child: const CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation(Color(0XFFEDF8E9)),
                      ),
                    );
                  } else if (state is FetchedPaymentMethods) {
                    final paymentCards = state.paymentCards;
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: paymentCards.length,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        final paymentCard = paymentCards[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 31.0),
                          child: InkWell(
                            onTap: () {
                              paymentMethodCubit.changePaymentMethod(
                                paymentCard.id,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: 90,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.asset(
                                      'assets/images/masterCard.png',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  height: 70,
                                  width: 222,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0XFFEDF8E9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Master Card',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                ),
                                              ),
                                              Text(
                                                paymentCard.cardNumber,
                                                style: TextStyle(
                                                  color: Color(0XFF41AB5D),
                                                ),
                                              ),
                                            ],
                                          ),
                                          BlocBuilder<
                                            PaymentMethodsCubit,
                                            PaymentMethodsState
                                          >(
                                            bloc: paymentMethodCubit,
                                            buildWhen: (previous, current) =>
                                                current is PaymentMethodChosen,
                                            builder: (context, state) {
                                              if (state
                                                  is PaymentMethodChosen) {
                                                final chosenPaymentMethod =
                                                    state.chosenPayment;
                                                return Transform.scale(
                                                  scale: 1.2,
                                                  child: Radio<String>(
                                                    fillColor:
                                                        WidgetStateColor.resolveWith(
                                                          (state) {
                                                            if (state.contains(
                                                              MaterialState
                                                                  .selected,
                                                            )) {
                                                              return Theme.of(
                                                                context,
                                                              ).primaryColor;
                                                            } else {
                                                              return Theme.of(
                                                                context,
                                                              ).primaryColor;
                                                            }
                                                          },
                                                        ),
                                                    value: paymentCard.id,
                                                    groupValue:
                                                        chosenPaymentMethod.id,
                                                    onChanged: (id) {
                                                      paymentMethodCubit
                                                          .changePaymentMethod(
                                                            id!,
                                                          );
                                                    },
                                                  ),
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is FetchingPaymentMethodsError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.addNewCardRoute);
                },
                child: SizedBox(
                  width: 342,
                  child: Card(
                    color: Color(0XFFEDF8E9),
                    elevation: 0,
                    child: ListTile(
                      leading: IconNavbar(
                        'assets/icons/plus.png',
                        Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        'Add New Payment Method',
                        style: TextStyle(
                          fontSize: 19,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
                bloc: paymentMethodCubit,
                listenWhen: (previous, current) =>
                    current is ConfirmPaymentSuccess,
                buildWhen: (previous, current) =>
                    current is ConfirmPaymentLoading ||
                    current is ConfirmPaymentSuccess ||
                    current is ConfirmPaymentFailure,
                listener: (context, state) {
                  if (state is ConfirmPaymentSuccess) {
                    Navigator.of(context).pop();
                  }
                },
                builder: (context, state) {
                  if (state is ConfirmPaymentLoading) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Color(0XFFEDF8E9),
                        ),
                        onPressed: null,
                        child: Transform.scale(
                          scale: 0.5,
                          child: CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation(
                              Color(0XFFEDF8E9),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Color(0XFFEDF8E9),
                      ),
                      onPressed: () {
                        paymentMethodCubit.confirmPaymentMethod();
                      },
                      child: Text(
                        'Confirm Payment',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
