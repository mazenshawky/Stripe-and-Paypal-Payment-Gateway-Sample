import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/utils/user.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/widgets/custom_button.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/payment_intent_input_model/payment_intent_input_model.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/presentation/controllers/cubit/payment_cubit.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/presentation/views/thank_you_view.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/presentation/views/widgets/payment_methods_list_view.dart';

class PaymentMethodsBottomSheet extends StatelessWidget {
  const PaymentMethodsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          PaymentMethodsListView(),
          SizedBox(height: 32),
          BlocConsumer<PaymentCubit, PaymentState>(
            listener: (context, state) {
              if (state is PaymentSuccess) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return const ThankYouView();
                    },
                  ),
                );
              }
              if (state is PaymentFailure) {
                Navigator.of(context).pop();
                SnackBar snackBar = SnackBar(content: Text(state.errorMessage));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            builder: (context, state) {
              return CustomButton(
                onTap: () {
                  PaymentIntentInputModel
                  paymentIntentInputModel = PaymentIntentInputModel(
                    amount: 67.54,
                    currency: 'USD',
                    
                    customerId: User.stripeCustomerId,
                  );
                  BlocProvider.of<PaymentCubit>(context).makePayment(
                    paymentIntentInputModel: paymentIntentInputModel,
                  );
                },
                text: 'Continue',
                isLoading: state is PaymentLoading ? true : false,
              );
            },
          ),
        ],
      ),
    );
  }
}
