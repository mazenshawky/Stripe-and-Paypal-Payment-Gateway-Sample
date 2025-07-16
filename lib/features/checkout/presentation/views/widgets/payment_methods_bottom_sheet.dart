import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/enums/payment_method.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/utils/api_keys.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/utils/user.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/core/widgets/custom_button.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/amount_model/amount_model.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/amount_model/details.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/item_list_model/order_item_model.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/item_list_model/item_list_model.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/data/models/payment_intent_request.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/presentation/controllers/cubit/payment_cubit.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/presentation/views/thank_you_view.dart';
import 'package:stripe_and_paypal_payment_gateway_sample/features/checkout/presentation/views/widgets/payment_methods_list_view.dart';

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
                  if (paymentMethod == PaymentMethod.stripe) {
                    executeStripePayment();
                  } else if (paymentMethod == PaymentMethod.paypal) {
                    final ({AmountModel amount, ItemListModel itemList})
                    transactions = getTransactionsData();
                    executePaypalPayment(context, transactions);
                  }
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

  void updatePaymentMethod({required int index}) {
    if (index == 0) {
      paymentMethod = PaymentMethod.stripe;
    } else if (index == 1) {
      paymentMethod = PaymentMethod.paypal;
    }
    setState(() {});
  }

  void executeStripePayment() {
    PaymentIntentRequest paymentIntentRequest = PaymentIntentRequest(
      amount: 67.54,
      currency: 'USD',
      customerId: User.stripeCustomerId,
    );
    BlocProvider.of<PaymentCubit>(
      context,
    ).makePayment(paymentIntentRequest: paymentIntentRequest);
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
          },
          onCancel: () {
            debugPrint('cancelled:');
          },
        ),
      ),
    );
  }

  ({AmountModel amount, ItemListModel itemList}) getTransactionsData() {
    final AmountModel amount = AmountModel(
      total: '100',
      currency: 'USD',
      details: Details(shipping: '0', shippingDiscount: 0, subtotal: '100'),
    );
    final List<OrderItemModel> orders = [
      OrderItemModel(currency: 'USD', name: 'Apple', price: '4', quantity: 10),
      OrderItemModel(currency: 'USD', name: 'Apple', price: '5', quantity: 12),
    ];
    final ItemListModel itemList = ItemListModel(orders: orders);

    return (amount: amount, itemList: itemList);
  }
}
