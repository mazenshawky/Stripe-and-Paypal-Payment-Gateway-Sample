import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/utils/api_keys.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/utils/api_service.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/stripe/ephemeral_key_response/ephemeral_key_response.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/stripe/init_payment_sheet_request.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/stripe/stripe_payment_intent_request.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/stripe/payment_intent_response/payment_intent_response.dart';

class StripeService {
  final ApiService apiService = ApiService();

  Future<PaymentIntentResponse> createPaymentIntent(
    StripePaymentIntentRequest stripePaymentIntentRequest,
  ) async {
    final response = await apiService.post(
      body: stripePaymentIntentRequest.toJson(),
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

  Future makePayment(
    StripePaymentIntentRequest stripePaymentIntentRequest,
  ) async {
    final PaymentIntentResponse paymentIntentResponse =
        await createPaymentIntent(stripePaymentIntentRequest);

    final EphemeralKeyResponse ephemeralKeyResponse = await createEphemeralKey(
      customerId: stripePaymentIntentRequest.customerId,
    );

    final InitPaymentSheetRequest initPaymentSheetRequest =
        InitPaymentSheetRequest(
          clientSecret: paymentIntentResponse.clientSecret!,
          ephemeralKeySecret: ephemeralKeyResponse.secret!,
          customerId: stripePaymentIntentRequest.customerId,
        );

    await initPaymentSheet(initPaymentSheetRequest: initPaymentSheetRequest);
    await displayPaymentSheet();
  }
}
