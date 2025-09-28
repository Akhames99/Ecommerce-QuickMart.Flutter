import 'package:ecommerce/Models/added_card_model.dart';
import 'package:ecommerce/Models/location_item_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/Models/add_to_cart_model.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  void getCartItems() {
    emit(CheckoutLoading());
    final cartitems = theCart;
    final double subTotal = cartitems.fold(
      0,
      (previousValue, item) =>
          previousValue + item.product.price * item.quantity,
    );
    final numOfProducts = theCart.fold(
      0,
      (previousValue, item) => previousValue + item.quantity,
    );
    final chosenPaymentCard = cards.firstWhere(
      (element) => element.isChosen == true,
      orElse: () => cards.first,
    );
    final chosenLocation = locations.firstWhere(
      (location) => location.isChosen == true,
      orElse: () => locations.first,
    );
    emit(
      CheckoutLoaded(
        cartItems: cartitems,
        totalAmount: subTotal + 10,
        numOfProducts: numOfProducts,
        chosenPaymentCard: chosenPaymentCard,
        chosenLocation: chosenLocation,
      ),
    );
  }
}
