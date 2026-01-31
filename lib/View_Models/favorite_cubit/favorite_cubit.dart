import 'package:ecommerce/Models/product_item_model.dart';
import 'package:ecommerce/Services/auth_services.dart';
import 'package:ecommerce/Services/favorite_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial()) {
    _initializeFavorites();
  }

  final favoriteServices = FavoriteServicesImpl();
  final authServices = AuthServicesImpl();

  bool _isLoading = false;

  // Initialize favorites when cubit is created
  Future<void> _initializeFavorites() async {
    try {
      final currentUser = authServices.currentUser();
      if (currentUser != null) {
        final favoriteProducts = await favoriteServices.getFavorites(
          currentUser.uid,
        );
        emit(FavoriteLoaded(favoriteProducts));
      }
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> getFavoriteProducts() async {
    // Prevent multiple simultaneous calls
    if (_isLoading) {
      print('getFavoriteProducts already in progress, skipping...');
      return;
    }

    _isLoading = true;
    emit(FavoriteLoading());
    try {
      final currentUser = authServices.currentUser();
      print('Fetching favorites for user: ${currentUser?.uid}');

      final favoriteProducts = await favoriteServices.getFavorites(
        currentUser!.uid,
      );

      print('Fetched ${favoriteProducts.length} favorites');
      emit(FavoriteLoaded(favoriteProducts));
    } catch (e) {
      print('Error fetching favorites: $e');
      emit(FavoriteError(e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  Future<void> addFavorite(ProductItemModel product) async {
    try {
      final currentUser = authServices.currentUser();
      print('Adding favorite: ${product.name} (${product.id})');

      await favoriteServices.addFavorite(currentUser!.uid, product);

      print('Favorite added to Firestore, refreshing list...');
      // Refresh the favorites list
      final favoriteProducts = await favoriteServices.getFavorites(
        currentUser.uid,
      );
      emit(FavoriteLoaded(favoriteProducts));
    } catch (e) {
      print('Error adding favorite: $e');
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> removeFavorite(String productId) async {
    emit(FavoriteRemoving(productId));
    try {
      final currentUser = authServices.currentUser();
      print('Removing favorite: $productId');

      await favoriteServices.removeFavorites(currentUser!.uid, productId);
      emit(FavoriteRemoved(productId));

      print('Favorite removed, refreshing list...');
      // Refresh the favorites list
      final favoriteProducts = await favoriteServices.getFavorites(
        currentUser.uid,
      );
      emit(FavoriteLoaded(favoriteProducts));
    } catch (e) {
      print('Error removing favorite: $e');
      emit(FavoriteRemoveError(e.toString()));
    }
  }
}
