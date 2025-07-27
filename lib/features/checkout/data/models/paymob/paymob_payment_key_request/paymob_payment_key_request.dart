import 'package:equatable/equatable.dart';

import 'billing_data.dart';

class PaymobPaymentKeyRequest extends Equatable {
  final int amount;
  final String currency;
  final List<dynamic> items;
  final List<int> paymentMethods;
  final BillingData billingData;

  const PaymobPaymentKeyRequest({
    required this.amount,
    required this.currency,
    required this.items,
    required this.paymentMethods,
    required this.billingData,
  });

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'currency': currency,
    'items': items,
    'payment_methods': paymentMethods,
    'billing_data': billingData.toJson(),
  };

  @override
  List<Object?> get props {
    return [amount, currency, items, paymentMethods, billingData];
  }
}
