part of 'checkout_cubit.dart';

sealed class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutLoaded extends CheckoutState {
  final List<AddToCartModel> cartItems;
  final double totalAmount;
  final int numOfProducts;
  final AddedCardModel? chosenPaymentCard;
  final LocationItemModel? chosenLocation;

  CheckoutLoaded({
    required this.cartItems,
    required this.totalAmount,
    required this.numOfProducts,
    this.chosenPaymentCard,
    this.chosenLocation,
  });
}

final class CheckoutError extends CheckoutState {
  final String message;

  CheckoutError({required this.message});
}
