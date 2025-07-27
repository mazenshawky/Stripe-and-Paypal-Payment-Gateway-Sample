import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:payment_integration_sample/core/enums/payment_method.dart';
import 'package:payment_integration_sample/core/functions/get_transactions.dart';
import 'package:payment_integration_sample/core/utils/api_keys.dart';
import 'package:payment_integration_sample/core/utils/user.dart';
import 'package:payment_integration_sample/core/widgets/custom_button.dart';
import 'package:payment_integration_sample/features/checkout/data/models/paypal/amount_model/amount_model.dart';
import 'package:payment_integration_sample/features/checkout/data/models/paypal/item_list_model/item_list_model.dart';
import 'package:payment_integration_sample/features/checkout/data/models/stripe/stripe_payment_intent_request.dart';
import 'package:payment_integration_sample/features/checkout/data/models/paymob/paymob_payment_intent_request.dart';
import 'package:payment_integration_sample/features/checkout/presentation/controllers/paymob_payment_cubit/paymob_payment_cubit.dart';
import 'package:payment_integration_sample/features/checkout/presentation/controllers/stripe_payment_cubit/stripe_payment_cubit.dart';
import 'package:payment_integration_sample/features/checkout/presentation/views/paymob_view.dart';
import 'package:payment_integration_sample/features/checkout/presentation/views/thank_you_view.dart';
import 'package:payment_integration_sample/features/checkout/presentation/views/widgets/payment_methods_list_view.dart';

class PaymentMethodsBottomSheet extends StatefulWidget {
  const PaymentMethodsBottomSheet({super.key});

  @override
  State<PaymentMethodsBottomSheet> createState() =>
      _PaymentMethodsBottomSheetState();
}

class _PaymentMethodsBottomSheetState extends State<PaymentMethodsBottomSheet> {
  PaymentMethod paymentMethod = PaymentMethod.stripe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          PaymentMethodsListView(updatePaymentMethod: updatePaymentMethod),
          SizedBox(height: 32),
          MultiBlocListener(
            listeners: [
              BlocListener<StripePaymentCubit, StripePaymentState>(
                listener: (context, state) {
                  if (state is StripePaymentSuccess) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return const ThankYouView();
                        },
                      ),
                    );
                  }
                  if (state is StripePaymentFailure) {
                    Navigator.of(context).pop();
                    SnackBar snackBar = SnackBar(
                      content: Text(state.errorMessage),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
              BlocListener<PaymobPaymentCubit, PaymobPaymentState>(
                listener: (context, state) {
                  if (state is PaymobPaymentSuccess) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return PaymobPaymentView(paymentKey: state.key);
                        },
                      ),
                    );
                  }
                  if (state is PaymobPaymentFailure) {
                    Navigator.of(context).pop();
                    SnackBar snackBar = SnackBar(
                      content: Text(state.errorMessage),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ],
            child: SizedBox.shrink(),
          ),
          BlocBuilder<StripePaymentCubit, StripePaymentState>(
            builder: (context, stripeState) {
              final paymobState = context.watch<PaymobPaymentCubit>().state;
              final isLoading =
                  stripeState is StripePaymentLoading ||
                  paymobState is PaymobPaymentLoading;
              return CustomButton(
                onTap: () {
                  if (paymentMethod == PaymentMethod.stripe) {
                    executeStripePayment();
                  } else if (paymentMethod == PaymentMethod.paypal) {
                    final ({AmountModel amount, ItemListModel itemList})
                    transactions = getTransactionsData();
                    executePaypalPayment(context, transactions);
                  } else if (paymentMethod == PaymentMethod.paymob) {
                    executePaymobPayment();
                  }
                },
                text: 'Continue',
                isLoading: isLoading,
              );
            },
          ),
        ],
      ),
    );
  }

  void updatePaymentMethod({required int index}) {
    if (index == 0) {
      paymentMethod = PaymentMethod.stripe;
    } else if (index == 1) {
      paymentMethod = PaymentMethod.paypal;
    } else if (index == 2) {
      paymentMethod = PaymentMethod.paymob;
    }
    setState(() {});
  }

  void executeStripePayment() {
    StripePaymentIntentRequest stripePaymentIntentRequest = StripePaymentIntentRequest(
      amount: 67.54,
      currency: 'USD',
      customerId: User.stripeCustomerId,
    );
    BlocProvider.of<StripePaymentCubit>(
      context,
    ).makePayment(stripePaymentIntentRequest: stripePaymentIntentRequest);
  }

  void executePaypalPayment(
    BuildContext context,
    ({AmountModel amount, ItemListModel itemList}) transactions,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true,
          clientId: ApiKeys.paypalClientId,
          secretKey: ApiKeys.paypalSecretKey,
          transactions: [
            {
              "amount": transactions.amount.toJson(),
              "description": "The payment transaction description.",
              "item_list": transactions.itemList.toJson(),
            },
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            debugPrint("onSuccess: $params");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const ThankYouView();
                },
              ),
              (route) => route.settings.name == '/',
            );
          },
          onError: (error) {
            debugPrint("onError: $error");
            Navigator.pop(context);
            Navigator.pop(context);
            SnackBar snackBar = SnackBar(content: Text(error.toString()));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          onCancel: () {
            debugPrint('cancelled:');
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void executePaymobPayment() {
    PaymobPaymentIntentRequest paymobPaymentIntentRequest =
        PaymobPaymentIntentRequest(
          amount: 467.34,
          currency: 'EGP',
          paymentMethodId: 5194151,
        );
    BlocProvider.of<PaymobPaymentCubit>(context).getPaymobPaymentKey(
      paymobPaymentIntentRequest: paymobPaymentIntentRequest,
    );
  }
}
