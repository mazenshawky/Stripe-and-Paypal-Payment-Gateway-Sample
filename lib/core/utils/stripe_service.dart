import 'package:stripe_and_paypal_payment_gateway_sample/core/utils/api_keys.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/utils/api_service.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/payment_intent_input_model/payment_intent_input_model.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/payment_intent_model/payment_intent_model.dart';

class StripeService {
  final ApiService apiService = ApiService();

  Future<PaymentIntentModel> createPaymentIntent(
    PaymentIntentInputModel paymentIntentInputModel,
  ) async {
    final response = await apiService.post(
      body: paymentIntentInputModel.toJson(),
      url: 'https://api.stripe.com/v1/payment_intents',
      token: ApiKeys.stripeSecretKey,
    );

    PaymentIntentModel paymentIntentModel = PaymentIntentModel.fromJson(
      response.data,
    );

    return paymentIntentModel;
  }
}
