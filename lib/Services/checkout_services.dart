import 'package:ecommerce/Models/added_card_model.dart';
import 'package:ecommerce/Models/add_to_cart_model.dart';
import 'package:ecommerce/Services/firestore_services.dart';
import 'package:ecommerce/Utils/api_paths.dart';

abstract class CheckoutServices {
  Future<void> setCard(String userId, AddedCardModel paymentCard);
  Future<List<AddedCardModel>> fetchPaymentMethods(
    String userId, [
    bool chosen = false,
  ]);
  Future<AddedCardModel> fetchSinglePaymentMethods(
    String userId,
    String paymentId,
  );
  Future<List<AddToCartModel>> fetchCartItems(String userId);
}

class CheckoutServicesImpl implements CheckoutServices {
  final fireStoreServices = FirestoreServices.instance;

  @override
  Future<void> setCard(String userId, AddedCardModel paymentCard) async =>
      await fireStoreServices.setData(
        path: ApiPaths.paymentCard(userId, paymentCard.id),
        data: paymentCard.toMap(),
      );

  @override
  Future<List<AddedCardModel>> fetchPaymentMethods(
    String userId, [
    bool chosen = false,
  ]) async => await fireStoreServices.getCollection(
    path: ApiPaths.paymentCards(userId),
    builder: (data, documentId) => AddedCardModel.fromMap(data),
    queryBuilder: chosen
        ? (query) => query.where('isChosen', isEqualTo: true)
        : null,
  );

  @override
  Future<AddedCardModel> fetchSinglePaymentMethods(
    String userId,
    String paymentId,
  ) async => await fireStoreServices.getDocument(
    path: ApiPaths.paymentCard(userId, paymentId),
    builder: (data, documentId) => AddedCardModel.fromMap(data),
  );

  @override
  Future<List<AddToCartModel>> fetchCartItems(String userId) async =>
      await fireStoreServices.getCollection(
        path: ApiPaths.cartItems(userId),
        builder: (data, documentId) => AddToCartModel.fromMap(data),
      );
}
