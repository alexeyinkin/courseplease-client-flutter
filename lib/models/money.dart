import 'package:easy_localization/easy_localization.dart';

class Money {
  final Map<String, double> map;

  Money(this.map);

  factory Money.fromMapOrList(dynamic mapOrEmptyList) {
    final map = Map<String, double>();

    if (mapOrEmptyList is Map) {
      for (final cur in mapOrEmptyList.keys) {
        map[cur] = mapOrEmptyList[cur].toDouble();
      }
    }

    return Money(map);
  }

  String toString() {
    final parts = <String>[];

    for (final cur in map.keys) {
      final value = map[cur];
      var valueString;

      valueString = value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
      parts.add(valueString + ' ' + curToSymbol(cur));
    }

    return parts.join(' + ');
  }

  String formatPer(String per) {
    final unit = tr('util.units.' + per);
    return tr('util.amountPerUnit', namedArgs: {'amount': toString(), 'unit': unit});
  }

  bool isZero() {
    for (final cur in map.keys) {
      if (map[cur] != 0) return false;
    }

    return true;
  }

  static String curToSymbol(String cur) {
    switch (cur) {
      case 'USD': return '\$';
      case 'EUR': return '€';
      case 'RUB': return '₽';
    }
    return cur;
  }
}
