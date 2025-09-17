part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  List<HomeCarouselItemModel> carouselItems;
  List<ProductItemModel> products;

  HomeLoaded({required this.carouselItems, required this.products});
}

final class HomeError extends HomeState {
  final String errorMessage;

  HomeError({required this.errorMessage});
}
