part of 'favorite_cubit.dart';

sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoading extends FavoriteState {}

final class FavoriteLoaded extends FavoriteState {
  final List<ProductItemModel> favoriteProducts;

  FavoriteLoaded(this.favoriteProducts);
}

final class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError(this.message);
}

final class FavoriteRemoved extends FavoriteState {
  final String productId;

  FavoriteRemoved(this.productId);
}

final class FavoriteRemoving extends FavoriteState {
  final String productId;

  FavoriteRemoving(this.productId);
}

final class FavoriteRemoveError extends FavoriteState {
  final String message;

  FavoriteRemoveError(this.message);
}
