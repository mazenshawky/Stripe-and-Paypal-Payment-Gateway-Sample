part of 'paymob_payment_cubit.dart';

sealed class PaymobPaymentState extends Equatable {
  const PaymobPaymentState();

  @override
  List<Object> get props => [];
}

final class PaymobPaymentInitial extends PaymobPaymentState {}

final class PaymobPaymentLoading extends PaymobPaymentState {}

final class PaymobPaymentSuccess extends PaymobPaymentState {
  final String key;

  const PaymobPaymentSuccess({required this.key});
}

final class PaymobPaymentFailure extends PaymobPaymentState {
  final String errorMessage;

  const PaymobPaymentFailure({required this.errorMessage});
}
