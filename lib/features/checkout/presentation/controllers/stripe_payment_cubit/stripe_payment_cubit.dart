import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_integration_sample/core/errors/failures.dart';
import 'package:payment_integration_sample/features/checkout/data/models/stripe/stripe_payment_intent_request.dart';
import 'package:payment_integration_sample/features/checkout/data/repos/checkout_repo.dart';

part 'stripe_payment_state.dart';

class StripePaymentCubit extends Cubit<StripePaymentState> {
  StripePaymentCubit(this.checkoutRepo) : super(StripePaymentInitial());

  final CheckoutRepo checkoutRepo;

  Future makePayment({
    required StripePaymentIntentRequest stripePaymentIntentRequest,
  }) async {
    emit(StripePaymentLoading());
    final Either<Failure, void> data = await checkoutRepo.makePaymentWithStripe(
      stripePaymentIntentRequest: stripePaymentIntentRequest,
    );

    data.fold(
      (Failure failure) =>
          emit(StripePaymentFailure(errorMessage: failure.errorMessage)),
      (void r) => emit(StripePaymentSuccess()),
    );
  }

  @override
  void onChange(Change<StripePaymentState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
