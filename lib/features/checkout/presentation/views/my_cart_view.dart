import 'package:flutter/material.dart';
import 'package:payment_integration_sample/Features/checkout/presentation/views/widgets/my_cart_view_body.dart';
import 'package:payment_integration_sample/core/widgets/cutom_app_bar.dart';

class MyCartView extends StatelessWidget {
  const MyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'My Cart'),
      body: const MyCartViewBody(),
    );
  }
}
