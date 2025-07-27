import 'package:dartz/dartz.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_integration_sample/core/errors/failures.dart';
import 'package:payment_integration_sample/core/utils/paymob_service.dart';
import 'package:payment_integration_sample/core/utils/stripe_service.dart';
import 'package:payment_integration_sample/features/checkout/data/models/stripe/stripe_payment_intent_request.dart';
import 'package:payment_integration_sample/features/checkout/data/models/paymob/paymob_payment_intent_request.dart';
import 'package:payment_integration_sample/features/checkout/data/repos/checkout_repo.dart';

class CheckoutRepoImpl implements CheckoutRepo {
  final StripeService stripeService = StripeService();
  final PaymobService paymobService = PaymobService();

  @override
  Future<Either<Failure, void>> makePaymentWithStripe({
    required StripePaymentIntentRequest stripePaymentIntentRequest,
  }) async {
    try {
      await stripeService.makePayment(stripePaymentIntentRequest);

      return right(null);
    } on StripeException catch (e) {
      return left(
        ServerFailure(
          errorMessage: e.error.message ?? 'Unknown error occured!',
        ),
      );
    } on Exception catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getPaymobPaymentKey({
    required PaymobPaymentIntentRequest paymobPaymentIntentRequest,
  }) async {
    try {
      final String key = await paymobService.getPaymentKey(
        paymobPaymentIntentRequest,
      );

      return right(key);
    } on Exception catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
