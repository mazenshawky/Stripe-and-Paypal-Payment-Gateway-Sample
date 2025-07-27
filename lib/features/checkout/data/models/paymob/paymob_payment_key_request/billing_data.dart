import 'package:equatable/equatable.dart';

class BillingData extends Equatable {
  final String apartment;
  final String email;
  final String floor;
  final String firstName;
  final String street;
  final String building;
  final String phoneNumber;
  final String shippingMethod;
  final String postalCode;
  final String city;
  final String country;
  final String lastName;
  final String state;

  const BillingData({
    required this.apartment,
    required this.email,
    required this.floor,
    required this.firstName,
    required this.street,
    required this.building,
    required this.phoneNumber,
    required this.shippingMethod,
    required this.postalCode,
    required this.city,
    required this.country,
    required this.lastName,
    required this.state,
  });

  factory BillingData.fromJson(Map<String, dynamic> json) => BillingData(
    apartment: json['apartment'] as String,
    email: json['email'] as String,
    floor: json['floor'] as String,
    firstName: json['first_name'] as String,
    street: json['street'] as String,
    building: json['building'] as String,
    phoneNumber: json['phone_number'] as String,
    shippingMethod: json['shipping_method'] as String,
    postalCode: json['postal_code'] as String,
    city: json['city'] as String,
    country: json['country'] as String,
    lastName: json['last_name'] as String,
    state: json['state'] as String,
  );

  Map<String, dynamic> toJson() => {
    'apartment': apartment,
    'email': email,
    'floor': floor,
    'first_name': firstName,
    'street': street,
    'building': building,
    'phone_number': phoneNumber,
    'shipping_method': shippingMethod,
    'postal_code': postalCode,
    'city': city,
    'country': country,
    'last_name': lastName,
    'state': state,
  };

  @override
  List<Object?> get props {
    return [
      apartment,
      email,
      floor,
      firstName,
      street,
      building,
      phoneNumber,
      shippingMethod,
      postalCode,
      city,
      country,
      lastName,
      state,
    ];
  }
}
