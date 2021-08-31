// http://www.cbr.ru/development/sxml/

import 'package:courseplease/services/shop/currency_converter.dart';

class CachedMapCurrencyConverter extends CurrencyConverter {
  var _map = <String, double>{};

  void addAll(Map<String, double> map) {
    _map.addAll(map);
  }

  @override
  double convert({
    required double amount,
    required String from,
    required String to,
  }) {
    final fromRate = _map[from];
    final toRate = _map[to];

    if (fromRate == null || toRate == null) {
      throw Exception('Cannot convert ' + from + ' to ' + to);
    }

    return amount * fromRate / toRate;
  }
}
