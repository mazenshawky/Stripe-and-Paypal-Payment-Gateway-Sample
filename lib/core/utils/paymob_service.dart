import 'package:payment_integration_sample/core/utils/api_keys.dart';
import 'package:payment_integration_sample/core/utils/api_service.dart';
import 'package:payment_integration_sample/core/utils/helpers.dart';
import 'package:payment_integration_sample/features/checkout/data/models/paymob/paymob_payment_intent_request.dart';
import 'package:payment_integration_sample/features/checkout/data/models/paymob/paymob_payment_key_request/billing_data.dart';
import 'package:payment_integration_sample/features/checkout/data/models/paymob/paymob_payment_key_request/paymob_payment_key_request.dart';
import 'package:payment_integration_sample/features/checkout/data/models/paymob/paymob_payment_key_response/paymob_payment_key_response.dart';

class PaymobService {
  final ApiService apiService = ApiService();
  // get the payment methods ids from developers -> payment integrations
  // all the NA data in billing data are not required
  // for the expected 201 response, head to response section:
  // https://developers.paymob.com/egypt/payment-types/pay-with-saved-token-moto/how-to-generate-payment-key
  Future<String> getPaymentKey(
    PaymobPaymentIntentRequest paymobPaymentIntentRequest,
  ) async {
    final PaymobPaymentKeyRequest paymobPaymentKeyRequest =
        PaymobPaymentKeyRequest(
          amount: Helpers.convertToMinorUnits(
            paymobPaymentIntentRequest.amount,
          ), 
          currency: paymobPaymentIntentRequest.currency,
          items: [],
          paymentMethods: [paymobPaymentIntentRequest.paymentMethodId],
          billingData: BillingData(
            apartment: "NA",
            email: "me@email.com",
            floor: "NA",
            firstName: "Mazen",
            street: "NA",
            building: "NA",
            phoneNumber: "+201234567890",
            shippingMethod: "NA",
            postalCode: "NA",
            city: "NA",
            country: "NA",
            lastName: "Shawky",
            state: "NA",
          ),
        );

    final response = await apiService.post(
      body: paymobPaymentKeyRequest.toJson(),
      url: 'https://accept.paymob.com/v1/intention/',
      token: ApiKeys.paymobSecretKey,
      contentType: 'application/json',
      tokenType: 'Token',
    );
    if (response.statusCode == 201) {
      final PaymobPaymentKeyResponse paymobPaymentKeyResponse =
          PaymobPaymentKeyResponse.fromJson(response.data);
      return paymobPaymentKeyResponse.paymentKeys.first.key;
    } else {
      throw Exception('Failed to get payment key');
    }
  }
}
