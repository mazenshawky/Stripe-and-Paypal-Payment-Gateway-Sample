import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/Features/checkout/presentation/views/widgets/total_price_widget.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/repos/checkout_repo_impl.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/presentation/controllers/cubit/payment_cubit.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/presentation/views/widgets/cart_info_item.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/presentation/views/widgets/payment_methods_bottom_sheet.dart';

class MyCartViewBody extends StatelessWidget {
  const MyCartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Expanded(child: Image.asset('assets/images/basket_image.png')),
          const SizedBox(height: 25),
          const OrderInfoItem(title: 'Order Subtotal', value: r'42.97$'),
          const SizedBox(height: 3),
          const OrderInfoItem(title: 'Discount', value: r'0$'),
          const SizedBox(height: 3),
          const OrderInfoItem(title: 'Shipping', value: r'8$'),
          const Divider(thickness: 2, height: 34, color: Color(0xffC7C7C7)),
          const TotalPrice(title: 'Total', value: r'$50.97'),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Complete Payment',
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                builder: (context) {
                  return BlocProvider(
                    create: (context) => PaymentCubit(CheckoutRepoImpl()),
                    child: const PaymentMethodsBottomSheet(),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
