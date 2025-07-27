import 'package:stripe_and_paypal_payment_gateway_sample/core/utils/helpers.dart';

class PaymobPaymentIntentRequest {
  final double amount;
  final String currency;
  final int paymentMethodId;

  PaymobPaymentIntentRequest({
    required this.amount,
    required this.currency,
    required this.paymentMethodId,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': Helpers.convertToMinorUnits(amount),
      'currency': currency,
      'customer': paymentMethodId,
    };
  }
}
