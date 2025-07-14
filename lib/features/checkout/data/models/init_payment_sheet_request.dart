class InitPaymentSheetRequest {
  final String clientSecret;
  final String ephemeralKeySecret;
  final String customerId;

  InitPaymentSheetRequest({
    required this.clientSecret,
    required this.ephemeralKeySecret,
    required this.customerId,
  });
}
