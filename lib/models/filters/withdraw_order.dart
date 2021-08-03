import 'package:courseplease/models/filters/abstract.dart';

class WithdrawOrderFilter extends AbstractFilter {
  final int status;

  WithdrawOrderFilter({
    required this.status,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}
