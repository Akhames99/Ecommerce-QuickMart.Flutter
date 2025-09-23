part of 'cart_cubit.dart';

sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<AddToCartModel> cartItems;
  final double subTotal;

  CartLoaded({required this.cartItems, required this.subTotal});
}

final class CartError extends CartState {
  final String message;

  CartError({required this.message});
}

final class CounterQuantityLoaded extends CartState {
  final int value;
  final String productId;

  CounterQuantityLoaded({required this.value, required this.productId});
}
