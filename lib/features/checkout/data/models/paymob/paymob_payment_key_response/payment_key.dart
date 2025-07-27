import 'package:equatable/equatable.dart';

class PaymentKey extends Equatable {
  final String key;

  const PaymentKey({required this.key});

  factory PaymentKey.fromJson(Map<String, dynamic> json) =>
      PaymentKey(key: json['key'] as String);

  @override
  List<Object?> get props => [key];
}
