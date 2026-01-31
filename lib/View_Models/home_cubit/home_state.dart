part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<HomeCarouselItemModel> carouselItems;
  final List<ProductItemModel> products;

  HomeLoaded({required this.carouselItems, required this.products});
}

class HomeError extends HomeState {
  final String errorMessage;

  HomeError({required this.errorMessage});
}

class SetFavoriteLoading extends HomeState {
  final String productId;

  SetFavoriteLoading({required this.productId});
}

class SetFavoriteSuccess extends HomeState {
  final String productId;
  final bool isFavorite;

  SetFavoriteSuccess({required this.productId, required this.isFavorite});
}

class SetFavoriteError extends HomeState {
  final String productId;
  final String errorMessage;

  SetFavoriteError({required this.productId, required this.errorMessage});
}
