import 'package:ecommerce/Models/added_card_model.dart';
import 'package:ecommerce/Models/location_item_model.dart';
import 'package:ecommerce/Services/auth_services.dart';
import 'package:ecommerce/Services/cart_services.dart';
import 'package:ecommerce/Services/checkout_services.dart';
import 'package:ecommerce/Services/location_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/Models/add_to_cart_model.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  final checkoutServices = CheckoutServicesImpl();
  final authServices = AuthServicesImpl();
  final locationServices = LocationServicesImpl();
  final cartServices = CartServicesImpl();

  Future<void> getCheckoutContent() async {
    emit(CheckoutLoading());
    try {
      final currentUser = await authServices.currentUser();

      final cartitems = await cartServices.fetchCartItems(currentUser!.uid);

      // Check if cart is empty
      if (cartitems.isEmpty) {
        emit(CheckoutError('Your cart is empty'));
        return;
      }

      final double subTotal = cartitems.fold(
        0,
        (previousValue, item) =>
            previousValue + item.product.price * item.quantity,
      );
      final numOfProducts = cartitems.fold(
        0,
        (previousValue, item) => previousValue + item.quantity,
      );

      final paymentMethods = await checkoutServices.fetchPaymentMethods(
        currentUser.uid,
        true,
      );
      final chosenPaymentCard = paymentMethods.isNotEmpty
          ? paymentMethods.first
          : null;

      // Fetch chosen location - with proper error handling
      final locations = await locationServices.fetchLocations(
        currentUser.uid,
        true,
      );

      final chosenLocation = locations.isNotEmpty ? locations.first : null;

      emit(
        CheckoutLoaded(
          cartItems: cartitems,
          totalAmount: subTotal + 10,
          numOfProducts: numOfProducts,
          chosenPaymentCard: chosenPaymentCard,
          chosenLocation: chosenLocation,
        ),
      );
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }
}
