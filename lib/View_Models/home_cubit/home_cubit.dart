import 'package:ecommerce/Models/home_carousel_item_model.dart';
import 'package:ecommerce/Models/product_item_model.dart';
import 'package:ecommerce/Services/auth_services.dart';
import 'package:ecommerce/Services/favorite_services.dart';
import 'package:ecommerce/Services/home_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final HomeServicesImpl homeServices = HomeServicesImpl();
  final AuthServicesImpl authServices = AuthServicesImpl();
  final FavoriteServicesImpl favoriteServices = FavoriteServicesImpl();

  // Local cached data inside the cubit
  List<ProductItemModel> _products = [];
  List<HomeCarouselItemModel> _carouselItems = [];
  bool _isLoaded = false;

  /// Fetch home data. If [forceRefresh] is true, bypass local cache.
  Future<void> getHomeData({bool forceRefresh = false}) async {
    // If already loaded and no force refresh — just re-emit current HomeLoaded
    if (_isLoaded && !forceRefresh) {
      emit(HomeLoaded(carouselItems: _carouselItems, products: _products));
      return;
    }

    emit(HomeLoading());
    try {
      final currentUser = authServices.currentUser();
      final products = await homeServices.fetchProducts();
      final carouselItems = homeCarousel; // static carousel items
      final favoriteProducts = currentUser != null
          ? await favoriteServices.getFavorites(currentUser.uid)
          : <ProductItemModel>[];

      // Merge favorites flag into products
      _products = products.map((product) {
        final isFavorite = favoriteProducts.any((fav) => fav.id == product.id);
        return product.copyWith(isFavorite: isFavorite);
      }).toList();

      _carouselItems = carouselItems;
      _isLoaded = true;

      emit(HomeLoaded(carouselItems: _carouselItems, products: _products));
    } catch (e) {
      emit(HomeError(errorMessage: e.toString()));
    }
  }

  /// Toggle favorite for a product (optimistic update).
  Future<void> setFavorite(ProductItemModel product) async {
    final currentUser = authServices.currentUser();
    if (currentUser == null) {
      emit(HomeError(errorMessage: 'User not authenticated'));
      return;
    }

    // Determine current favorite state from local cache
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index == -1) {
      // product not in local list — safe fallback: refresh data
      await getHomeData(forceRefresh: true);
      return;
    }

    final currentlyFavorite = _products[index].isFavorite;
    final newFavoriteValue = !currentlyFavorite;

    // 1) Optimistically update local cache and emit HomeLoaded so UI updates immediately
    _products[index] = _products[index].copyWith(isFavorite: newFavoriteValue);
    emit(HomeLoaded(carouselItems: _carouselItems, products: _products));

    // 2) Try to sync change with backend (Firebase)
    try {
      if (newFavoriteValue) {
        await favoriteServices.addFavorite(currentUser.uid, _products[index]);
      } else {
        await favoriteServices.removeFavorites(
          currentUser.uid,
          _products[index].id,
        );
      }

      // success -> emit HomeLoaded again to confirm
      emit(HomeLoaded(carouselItems: _carouselItems, products: _products));
    } catch (e) {
      // revert local change on failure
      _products[index] = _products[index].copyWith(
        isFavorite: currentlyFavorite,
      );
      emit(HomeLoaded(carouselItems: _carouselItems, products: _products));
    }
  }

  /// Optional: refresh favorites from server and merge into current products
  Future<void> refreshFavoritesFromServer() async {
    final currentUser = authServices.currentUser();
    if (currentUser == null) return;

    try {
      final favoriteProducts = await favoriteServices.getFavorites(
        currentUser.uid,
      );

      // Merge favorite flags into _products
      _products = _products.map((product) {
        final isFavorite = favoriteProducts.any((fav) => fav.id == product.id);
        return product.copyWith(isFavorite: isFavorite);
      }).toList();

      emit(HomeLoaded(carouselItems: _carouselItems, products: _products));
    } catch (_) {}
  }

  Future<void> clearCacheAndReload() async {
    _products = [];
    _carouselItems = [];
    _isLoaded = false;
    await getHomeData(forceRefresh: true);
  }
}
