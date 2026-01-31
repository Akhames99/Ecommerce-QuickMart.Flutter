import 'package:ecommerce/Models/added_card_model.dart';
import 'package:ecommerce/Services/auth_services.dart';
import 'package:ecommerce/Services/checkout_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  PaymentMethodsCubit() : super(PaymentMethodsInitial());

  String? selectedPaymentId;
  final checkOutServices = CheckoutServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> addNewCard(
    String cardNumber,
    String cardHolder,
    String expiryDate,
    String cvvCode,
  ) async {
    emit(NewCardLoading());
    try {
      final newCard = AddedCardModel(
        id: DateTime.now().toIso8601String(),
        cardNumber: cardNumber,
        cardHolder: cardHolder,
        expiryDate: expiryDate,
        cvvCode: cvvCode,
      );
      final currentUser = authServices.currentUser();
      await checkOutServices.setCard(currentUser!.uid, newCard);
      emit(NewCardLoaded());
    } catch (e) {
      emit(NewCardError(message: e.toString()));
    }
  }

  Future<void> fetchPaymentMethods() async {
    emit(FetchingPaymentMethods());
    try {
      final currentUser = authServices.currentUser();
      final paymentCards = await checkOutServices.fetchPaymentMethods(
        currentUser!.uid,
      );
      emit(FetchedPaymentMethods(paymentCards: paymentCards));
      if (paymentCards.isNotEmpty) {
        final paymentMethodChosen = paymentCards.firstWhere(
          (card) => card.isChosen,
          orElse: () => paymentCards.first,
        );
        selectedPaymentId = paymentMethodChosen.id;
        emit(PaymentMethodChosen(paymentMethodChosen));
      }
    } catch (e) {
      emit(FetchingPaymentMethodsError(message: e.toString()));
    }
  }

  Future<void> changePaymentMethod(String id) async {
    try {
      selectedPaymentId = id;
      final tempChosenPaymentMethod = await checkOutServices
          .fetchSinglePaymentMethods(
            authServices.currentUser()!.uid,
            selectedPaymentId!,
          );
      emit(PaymentMethodChosen(tempChosenPaymentMethod));
    } catch (e) {
      emit(FetchingPaymentMethodsError(message: e.toString()));
    }
  }

  Future<void> confirmPaymentMethod() async {
    emit(ConfirmPaymentLoading());
    try {
      final currentUser = authServices.currentUser();
      final previousChosenPaymentMethod =
          (await checkOutServices.fetchPaymentMethods(
            currentUser!.uid,
            true,
          )).first.copyWith(isChosen: false);
      var chosenPaymentMethod = await checkOutServices
          .fetchSinglePaymentMethods(currentUser.uid, selectedPaymentId!);
      chosenPaymentMethod = chosenPaymentMethod.copyWith(isChosen: true);
      await checkOutServices.setCard(
        currentUser.uid,
        previousChosenPaymentMethod,
      );
      await checkOutServices.setCard(currentUser.uid, chosenPaymentMethod);
      emit(ConfirmPaymentSuccess());
    } catch (e) {
      emit(FetchingPaymentMethodsError(message: e.toString()));
    }
  }
}
