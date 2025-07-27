import 'package:stripe_and_paypal_payment_gateway_sample/core/utils/helpers.dart';

class StripePaymentIntentRequest {
  final double amount;
  final String currency;
  final String customerId;

  StripePaymentIntentRequest({
    required this.amount,
    required this.currency,
    required this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': Helpers.convertToMinorUnits(amount),
      'currency': currency,
      'customer': customerId,
    };
  }
}
