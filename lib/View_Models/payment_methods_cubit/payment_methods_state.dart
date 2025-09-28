part of 'Payment_methods_cubit.dart';

sealed class PaymentMethodsState {}

final class PaymentMethodsInitial extends PaymentMethodsState {}

final class NewCardLoading extends PaymentMethodsState {}

final class NewCardLoaded extends PaymentMethodsState {}

final class NewCardError extends PaymentMethodsState {
  final String message;

  NewCardError({required this.message});
}

final class FetchingPaymentMethods extends PaymentMethodsState {}

final class FetchedPaymentMethods extends PaymentMethodsState {
  final List<AddedCardModel> paymentCards;

  FetchedPaymentMethods({required this.paymentCards});
}

final class FetchingPaymentMethodsError extends PaymentMethodsState {
  final String message;

  FetchingPaymentMethodsError({required this.message});
}

final class PaymentMethodChosen extends PaymentMethodsState {
  final AddedCardModel chosenPayment;

  PaymentMethodChosen(this.chosenPayment);
}

final class ConfirmPaymentLoading extends PaymentMethodsState {}

final class ConfirmPaymentSuccess extends PaymentMethodsState {}

final class ConfirmPaymentFailure extends PaymentMethodsState {
  final String message;

  ConfirmPaymentFailure({required this.message});
}
