import 'package:equatable/equatable.dart';

import 'tip.dart';

class AmountDetails extends Equatable {
  final Tip? tip;

  const AmountDetails({this.tip});

  factory AmountDetails.fromJson(Map<String, dynamic> json) => AmountDetails(
    tip: json['tip'] == null
        ? null
        : Tip.fromJson(json['tip'] as Map<String, dynamic>),
  );

  @override
  List<Object?> get props => [tip];
}
