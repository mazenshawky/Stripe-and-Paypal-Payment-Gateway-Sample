import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/utils/api_keys.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/utils/api_service.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/ephemeral_key_response/ephemeral_key_response.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/init_payment_sheet_request.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/payment_intent_request.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/payment_intent_response/payment_intent_response.dart';

class StripeService {
  final ApiService apiService = ApiService();

  Future<PaymentIntentResponse> createPaymentIntent(
    PaymentIntentRequest paymentIntentRequest,
  ) async {
    final response = await apiService.post(
      body: paymentIntentRequest.toJson(),
      url: 'https://api.stripe.com/v1/payment_intents',
      token: ApiKeys.stripeSecretKey,
    );

    final PaymentIntentResponse paymentIntentResponse =
        PaymentIntentResponse.fromJson(response.data);

    return paymentIntentResponse;
  }

  Future<EphemeralKeyResponse> createEphemeralKey({
    required String customerId,
  }) async {
    final response = await apiService.post(
      body: {'customer': customerId},
      url: 'https://api.stripe.com/v1/ephemeral_keys',
      token: ApiKeys.stripeSecretKey,
      additionalHeaders: {'Stripe-Version': '2025-06-30.basil'},
    );

    final EphemeralKeyResponse ephemeralKeyResponse =
        EphemeralKeyResponse.fromJson(response.data);

    return ephemeralKeyResponse;
  }

  Future initPaymentSheet({
    required InitPaymentSheetRequest initPaymentSheetRequest,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: initPaymentSheetRequest.clientSecret,
        customerEphemeralKeySecret: initPaymentSheetRequest.ephemeralKeySecret,
        customerId: initPaymentSheetRequest.customerId,
        merchantDisplayName: 'Test Store',
      ),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment(PaymentIntentRequest paymentIntentRequest) async {
    final PaymentIntentResponse paymentIntentResponse =
        await createPaymentIntent(paymentIntentRequest);

    final EphemeralKeyResponse ephemeralKeyResponse = await createEphemeralKey(
      customerId: paymentIntentRequest.customerId,
    );

    final InitPaymentSheetRequest initPaymentSheetRequest =
        InitPaymentSheetRequest(
          clientSecret: paymentIntentResponse.clientSecret!,
          ephemeralKeySecret: ephemeralKeyResponse.secret!,
          customerId: paymentIntentRequest.customerId,
        );

    await initPaymentSheet(initPaymentSheetRequest: initPaymentSheetRequest);
    await displayPaymentSheet();
  }
}
