import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Models/add_to_cart_model.dart';
import 'package:ecommerce/Models/product_item_model.dart';
import 'package:ecommerce/Services/firestore_services.dart';
import 'package:ecommerce/Utils/api_paths.dart';

abstract class ProductDetailsServices {
  Future<ProductItemModel> fetchProductDetails(String productId);
  Future<void> addToCart(AddToCartModel cartItem, String userId);
}

class ProductDetailsServicesImpl implements ProductDetailsServices {
  final firestoreServices = FirestoreServices.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<ProductItemModel> fetchProductDetails(String productId) async {
    try {
      print('=== Fetching Product ===');
      print('Product ID: $productId');
      print('Path: ${ApiPaths.product(productId)}');

      // Try the existing method first
      try {
        final selectedProduct = await firestoreServices
            .getDocument<ProductItemModel>(
              path: ApiPaths.product(productId),
              builder: (data, documentId) {
                print('Data from firestoreServices: $data');
                if (data == null) {
                  throw Exception('Product data is null');
                }
                return ProductItemModel.fromMap(data);
              },
            );

        if (selectedProduct != null) {
          print(
            'Product fetched successfully via firestoreServices: ${selectedProduct.name}',
          );
          return selectedProduct;
        }
      } catch (e) {
        print('firestoreServices.getDocument failed: $e');
      }

      // Fallback: Direct Firestore access
      print('Trying direct Firestore access...');
      final docSnapshot = await _firestore
          .doc(ApiPaths.product(productId))
          .get();

      print('Document exists: ${docSnapshot.exists}');
      if (!docSnapshot.exists) {
        throw Exception(
          'Product document not found in Firestore for ID: $productId',
        );
      }

      final data = docSnapshot.data();
      print('Raw Firestore data: $data');

      if (data == null) {
        throw Exception('Product data is null from Firestore');
      }

      final product = ProductItemModel.fromMap(data);
      print('Product loaded successfully: ${product.name}');
      return product;
    } catch (e) {
      print('ERROR fetching product details: $e');
      print('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  @override
  Future<void> addToCart(AddToCartModel cartItem, String userId) async {
    await firestoreServices.setData(
      path: ApiPaths.cartItem(userId, cartItem.id),
      data: cartItem.toMap(),
    );
  }
}
