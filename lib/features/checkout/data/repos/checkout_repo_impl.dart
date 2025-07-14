import 'package:dartz/dartz.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/errors/failures.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/utils/stripe_service.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/payment_intent_input_model/payment_intent_input_model.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/repos/checkout_repo.dart';

class CheckoutRepoImpl implements CheckoutRepo {
  final StripeService stripeService = StripeService();

  @override
  Future<Either<Failure, void>> makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  }) async {
    try {
      await stripeService.makePayment(paymentIntentInputModel);

      return right(null);
    } on Exception catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
