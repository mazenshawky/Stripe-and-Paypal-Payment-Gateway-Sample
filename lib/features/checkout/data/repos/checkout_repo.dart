import 'package:dartz/dartz.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/errors/failures.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/stripe/stripe_payment_intent_request.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/paymob/paymob_payment_intent_request.dart';

abstract class CheckoutRepo {
  Future<Either<Failure, void>> makePaymentWithStripe({
    required StripePaymentIntentRequest stripePaymentIntentRequest,
  });

  Future<Either<Failure, String>> getPaymobPaymentKey({
    required PaymobPaymentIntentRequest paymobPaymentIntentRequest,
  });
}
