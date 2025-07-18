class PaymentIntentRequest {
  final double amount;
  final String currency;
  final String customerId;

  PaymentIntentRequest({
    required this.amount,
    required this.currency,
    required this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': convertToMinorUnits(amount),
      'currency': currency,
      'customer': customerId,
    };
  }
}

int convertToMinorUnits(double amount) => (amount * 100).round();
