import 'package:stripe_and_paypal_payment_gateway_sample/Features/checkout/presentation/views/widgets/payment_details_view_body.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/widgets/cutom_app_bar.dart';
import 'package:flutter/material.dart';

class PaymentDetailsView extends StatelessWidget {
  const PaymentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Payment Details'),
      body: const PaymentDetailsViewBody(),
    );
  }
}
