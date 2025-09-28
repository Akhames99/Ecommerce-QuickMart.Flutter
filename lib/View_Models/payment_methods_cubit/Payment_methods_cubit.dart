import 'package:ecommerce/Models/added_card_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  PaymentMethodsCubit() : super(PaymentMethodsInitial());

  String selectedPaymentId = cards.first.id;

  void addNewCard(
    String cardNumber,
    String cardHolder,
    String expiryDate,
    String cvvCode,
  ) {
    emit(NewCardLoading());
    final newCard = AddedCardModel(
      id: DateTime.now().toIso8601String(),
      cardNumber: cardNumber,
      cardHolder: cardHolder,
      expiryDate: expiryDate,
      cvvCode: cvvCode,
    );
    Future.delayed(Duration(seconds: 1), () {
      cards.add(newCard);
      emit(NewCardLoaded());
    });
  }

  void fetchPaymentMethods() {
    emit(FetchingPaymentMethods());
    Future.delayed(Duration(seconds: 1), () {
      if (cards.isNotEmpty) {
        final paymentMethodChosen = cards.firstWhere(
          (element) => element.isChosen == true,
          orElse: () => cards.first,
        );
        emit(FetchedPaymentMethods(paymentCards: cards));
        Future.delayed(Duration(milliseconds: 100), () {
          emit(PaymentMethodChosen(paymentMethodChosen));
        });
      } else {
        emit(FetchingPaymentMethodsError(message: 'No Payment Methods Found'));
      }
    });
  }

  void changePaymentMethod(String id) {
    selectedPaymentId = id;
    var tempChosenPaymentMethod = cards.firstWhere(
      (item) => item.id == selectedPaymentId,
    );
    emit(PaymentMethodChosen(tempChosenPaymentMethod));
  }

  void confirmPaymentMethod() {
    emit(ConfirmPaymentLoading());
    Future.delayed(Duration(seconds: 1), () {
      var chosenPaymentMethod = cards.firstWhere(
        (item) => item.id == selectedPaymentId,
      );
      var previousPaymentMethod = cards.firstWhere(
        (paymentCard) => paymentCard.isChosen == true,
        orElse: () => cards.first,
      );
      previousPaymentMethod = previousPaymentMethod.copyWith(isChosen: false);
      chosenPaymentMethod = chosenPaymentMethod.copyWith(isChosen: true);
      final previousIndex = cards.indexWhere(
        (paymentCard) => paymentCard.id == previousPaymentMethod.id,
      );
      final chosenIndex = cards.indexWhere(
        (paymentCard) => paymentCard.id == chosenPaymentMethod.id,
      );
      cards[previousIndex] = previousPaymentMethod;
      cards[chosenIndex] = chosenPaymentMethod;
      emit(ConfirmPaymentSuccess());
    });
  }
}
