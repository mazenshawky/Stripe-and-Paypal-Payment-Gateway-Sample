import 'package:dartz/dartz.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/errors/failures.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/utils/stripe_service.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/payment_intent_request.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/repos/checkout_repo.dart';

class CheckoutRepoImpl implements CheckoutRepo {
  final StripeService stripeService = StripeService();

  @override
  Future<Either<Failure, void>> makePayment({
    required PaymentIntentRequest paymentIntentRequest,
  }) async {
    try {
      await stripeService.makePayment(paymentIntentRequest);

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
}
