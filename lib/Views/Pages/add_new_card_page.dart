import 'package:ecommerce/View_Models/payment_methods_cubit/Payment_methods_cubit.dart';
import 'package:ecommerce/Views/Widgets/label_with_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewCardPage extends StatefulWidget {
  const AddNewCardPage({super.key});

  @override
  State<AddNewCardPage> createState() => _AddNewCardPageState();
}

class _AddNewCardPageState extends State<AddNewCardPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cardExpiredController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<PaymentMethodsCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Spacer(),
            Text(
              'Add New Card',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              LabelWithTextfield(
                label: 'Card Number',
                controller: _cardNumberController,
                imgPath: 'assets/icons/card.png',
                hintText: 'Enter Card Number',
              ),
              SizedBox(height: 10),
              LabelWithTextfield(
                label: 'Card Holder Name',
                controller: _cardHolderController,
                imgPath: 'assets/icons/person.png',
                hintText: 'Enter Holder Number',
              ),
              SizedBox(height: 10),
              LabelWithTextfield(
                label: 'Expired',
                controller: _cardExpiredController,
                imgPath: 'assets/icons/calender.png',
                hintText: 'MM/YY',
              ),
              SizedBox(height: 10),
              LabelWithTextfield(
                label: 'CVV',
                controller: _cvvController,
                imgPath: 'assets/icons/lock.png',
                hintText: 'CVV Code',
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  height: 44,
                  width: 197,
                  child: BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
                    bloc: cubit,
                    listenWhen: (previous, current) =>
                        current is NewCardLoaded || current is NewCardError,
                    listener: (context, state) {
                      if (state is NewCardLoaded) {
                        Navigator.pop(context);
                      } else if (state is NewCardError) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is NewCardLoading ||
                        current is NewCardLoaded ||
                        current is NewCardError,
                    builder: (context, state) {
                      if (state is NewCardLoading) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0XFF41AB5D),
                          ),
                          onPressed: null,
                          child: CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation(
                              Color(0XFFEDF8E9),
                            ),
                          ),
                        );
                      }
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFF41AB5D),
                          foregroundColor: Color(0XFFEDF8E9),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            cubit.addNewCard(
                              _cardNumberController.text,
                              _cardHolderController.text,
                              _cardExpiredController.text,
                              _cvvController.text,
                            );
                          }
                        },
                        child: Text('Add Card', style: TextStyle(fontSize: 20)),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
