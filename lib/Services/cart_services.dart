import 'package:ecommerce/Models/add_to_cart_model.dart';
import 'package:ecommerce/Services/firestore_services.dart';
import 'package:ecommerce/Utils/api_paths.dart';

abstract class CartServices {
  Future<List<AddToCartModel>> fetchCartItems(String userId);
  Future<void> setCartItem(String userId, AddToCartModel cartItem);
}

class CartServicesImpl implements CartServices {
  final fireStoreServices = FirestoreServices.instance;

  @override
  Future<List<AddToCartModel>> fetchCartItems(String userId) async =>
      await fireStoreServices.getCollection(
        path: ApiPaths.cartItems(userId),
        builder: (data, documentId) => AddToCartModel.fromMap(data),
      );

  @override
  Future<void> setCartItem(String userId, AddToCartModel cartItem) async {
    await fireStoreServices.setData(
      path: ApiPaths.cartItem(userId, cartItem.id),
      data: cartItem.toMap(),
    );
  }
}
