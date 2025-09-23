part of 'product_item_cubit.dart';

sealed class ProductItemState {}

final class ProductItemInitial extends ProductItemState {}

final class ProductItemLoading extends ProductItemState {}

final class ProductItemLoaded extends ProductItemState {
  final ProductItemModel product;

  ProductItemLoaded({required this.product});
}

final class sizeSelected extends ProductItemState {
  final productSize size;

  sizeSelected({required this.size});
}

final class CounterQuantityLoaded extends ProductItemState {
  final int value;

  CounterQuantityLoaded({required this.value});
}

final class ProductAddedToCart extends ProductItemState {
  final String productId;

  ProductAddedToCart({required this.productId});
}

final class ProductAddingToCart extends ProductItemState {}

final class ProductItemError extends ProductItemState {
  final String message;

  ProductItemError({required this.message});
}
