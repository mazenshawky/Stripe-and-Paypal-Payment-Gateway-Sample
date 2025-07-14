import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/errors/failures.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/payment_intent_input_model/payment_intent_input_model.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/repos/checkout_repo.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this.checkoutRepo) : super(PaymentInitial());

  final CheckoutRepo checkoutRepo;

  Future makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  }) async {
    emit(PaymentLoading());
    final Either<Failure, void> data = await checkoutRepo.makePayment(
      paymentIntentInputModel: paymentIntentInputModel,
    );

    data.fold(
      (Failure failure) =>
          emit(PaymentFailure(errorMessage: failure.errorMessage)),
      (void r) => emit(PaymentSuccess()),
    );
  }

  @override
  void onChange(Change<PaymentState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
