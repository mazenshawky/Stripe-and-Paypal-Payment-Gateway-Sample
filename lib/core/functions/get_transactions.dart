import 'package:payment_integration_sample/features/checkout/data/models/paypal/amount_model/amount_model.dart';
import 'package:payment_integration_sample/features/checkout/data/models/paypal/amount_model/details.dart';
import 'package:payment_integration_sample/features/checkout/data/models/paypal/item_list_model/item_list_model.dart';
import 'package:payment_integration_sample/features/checkout/data/models/paypal/item_list_model/order_item_model.dart';

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
