import 'package:ecommerce/Models/product_item_model.dart';
import 'package:ecommerce/Services/firestore_services.dart';
import 'package:ecommerce/Utils/api_paths.dart';

abstract class FavoriteServices {
  Future<void> addFavorite(String userId, ProductItemModel product);
  Future<void> removeFavorites(String userId, String productId);
  Future<List<ProductItemModel>> getFavorites(String userId);
}

class FavoriteServicesImpl implements FavoriteServices {
  final fireStoreServices = FirestoreServices.instance;

  @override
  Future<void> addFavorite(String userId, ProductItemModel product) async =>
      await fireStoreServices.setData(
        path: ApiPaths.favoriteProduct(userId, product.id),
        data: product.toMap(),
      );

  @override
  Future<List<ProductItemModel>> getFavorites(String userId) async =>
      await fireStoreServices.getCollection(
        path: ApiPaths.favoriteProducts(userId),
        builder: (data, documentId) => ProductItemModel.fromMap(data),
      );

  @override
  Future<void> removeFavorites(String userId, String productId) async =>
      await fireStoreServices.deleteData(
        path: ApiPaths.favoriteProduct(userId, productId),
      );
}
