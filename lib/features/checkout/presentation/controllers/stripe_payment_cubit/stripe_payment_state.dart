part of 'stripe_payment_cubit.dart';

sealed class StripePaymentState extends Equatable {
  const StripePaymentState();

  @override
  List<Object> get props => [];
}

final class StripePaymentInitial extends StripePaymentState {}

final class StripePaymentLoading extends StripePaymentState {}

final class StripePaymentSuccess extends StripePaymentState {}

final class StripePaymentFailure extends StripePaymentState {
  final String errorMessage;

  const StripePaymentFailure({required this.errorMessage});
}
