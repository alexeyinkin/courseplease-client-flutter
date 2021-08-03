import 'package:courseplease/models/filters/abstract.dart';

class WithdrawServiceFilter extends AbstractFilter {
  final String fromCur;

  WithdrawServiceFilter({
    required this.fromCur,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'fromCur': fromCur,
    };
  }
}
