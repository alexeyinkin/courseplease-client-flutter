import 'package:courseplease/models/filters/abstract.dart';

class MoneyAccountTransactionFilter extends AbstractFilter {
  final String cur;

  MoneyAccountTransactionFilter({
    required this.cur,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'cur': cur,
    };
  }
}
