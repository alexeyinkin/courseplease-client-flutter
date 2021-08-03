import 'package:courseplease/models/filters/abstract.dart';

class WithdrawAccountFilter extends AbstractFilter {
  final int serviceId;

  WithdrawAccountFilter({
    required this.serviceId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
    };
  }
}
