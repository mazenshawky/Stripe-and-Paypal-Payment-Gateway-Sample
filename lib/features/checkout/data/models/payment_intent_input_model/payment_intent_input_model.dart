class PaymentIntentInputModel {
  final double amount;
  final String currency;

  PaymentIntentInputModel({required this.amount, required this.currency});

  Map<String, dynamic> toJson() {
    return {'amount': convertToMinorUnits(amount), 'currency': currency};
  }
}

int convertToMinorUnits(double amount) => (amount * 100).round();
