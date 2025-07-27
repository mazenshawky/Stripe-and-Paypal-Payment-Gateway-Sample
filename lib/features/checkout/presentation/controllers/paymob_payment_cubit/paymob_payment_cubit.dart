import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/errors/failures.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/paymob/paymob_payment_intent_request.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/repos/checkout_repo.dart';

part 'paymob_payment_state.dart';

class PaymobPaymentCubit extends Cubit<PaymobPaymentState> {
  PaymobPaymentCubit(this.checkoutRepo) : super(PaymobPaymentInitial());

  final CheckoutRepo checkoutRepo;

  Future getPaymobPaymentKey({
    required PaymobPaymentIntentRequest paymobPaymentIntentRequest,
  }) async {
    emit(PaymobPaymentLoading());
    final Either<Failure, String> data = await checkoutRepo
        .getPaymobPaymentKey(
          paymobPaymentIntentRequest: paymobPaymentIntentRequest,
        );

    data.fold(
      (Failure failure) =>
          emit(PaymobPaymentFailure(errorMessage: failure.errorMessage)),
      (String key) => emit(PaymobPaymentSuccess(key: key)),
    );
  }

  @override
  void onChange(Change<PaymobPaymentState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
