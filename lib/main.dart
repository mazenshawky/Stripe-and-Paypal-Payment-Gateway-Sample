import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/Features/checkout/presentation/views/my_cart_view.dart';
import 'package:flutter/material.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/utils/api_keys.dart';

void main() async {
  Stripe.publishableKey = ApiKeys.stripePublishableKey;
  runApp(const CheckoutApp());
}

class CheckoutApp extends StatelessWidget {
  const CheckoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyCartView(),
    );
  }
}
