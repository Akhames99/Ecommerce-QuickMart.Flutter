import 'package:ecommerce/Models/product_item_model.dart';
import 'package:ecommerce/Services/firestore_services.dart';
import 'package:ecommerce/Utils/api_paths.dart';

abstract class HomeServices {
  Future<List<ProductItemModel>> fetchProducts();
}

class HomeServicesImpl implements HomeServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<List<ProductItemModel>> fetchProducts() async {
    final result = await firestoreServices.getCollection<ProductItemModel>(
      path: ApiPaths.products(),
      builder: (data, documentId) => ProductItemModel.fromMap(data),
    );
    return result;
  }
}
