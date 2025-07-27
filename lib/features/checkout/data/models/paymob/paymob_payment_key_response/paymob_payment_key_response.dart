import 'package:equatable/equatable.dart';

import 'payment_key.dart';

class PaymobPaymentKeyResponse extends Equatable {
  final List<PaymentKey> paymentKeys;

  const PaymobPaymentKeyResponse({required this.paymentKeys});

  factory PaymobPaymentKeyResponse.fromJson(Map<String, dynamic> json) {
    return PaymobPaymentKeyResponse(
      paymentKeys: (json['payment_keys'] as List<dynamic>)
          .map((e) => PaymentKey.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [paymentKeys];
}
