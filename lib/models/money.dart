import 'package:courseplease/utils/utils.dart';
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

  factory Money.zero() {
    return Money(Map<String, double>());
  }

  factory Money.fromNullableMap(Map<String?, double?> nullableMap) {
    final map = Map<String, double>();

    for (final entry in nullableMap.entries) {
      if (entry.key == null || entry.value == null) continue;
      map[entry.key!] = entry.value!;
    }

    return Money(map);
  }

  String toString() {
    final parts = <String>[];

    for (final entry in map.entries) {
      parts.add(formatMoneyValue(entry.value) + ' ' + curToSymbol(entry.key));
    }

    return parts.join(' + ');
  }

  String formatPer(String? per) {
    if (per == null) return toString();

    final unit = tr('util.units.' + per);
    return tr('util.amountPerUnit', namedArgs: {'amount': toString(), 'unit': unit});
  }

  bool isZero() {
    for (final cur in map.keys) {
      if (map[cur] != 0) return false;
    }

    return true;
  }

  bool isPositive() {
    // TODO: Convert. Now following the backend incomplete method.
    for (final value in map.values) {
      return value > 0;
    }
    return false;
  }

  static String curToSymbol(String cur) {
    switch (cur) {
      case 'USD': return '\$';
      case 'EUR': return '€';
      case 'RUB': return '₽';
    }
    return cur;
  }

  String? getFirstKey() {
    return map.isEmpty ? null : map.keys.first;
  }

  double? getFirstValue() {
    return map.isEmpty ? null : map[map.keys.first];
  }

  void replaceFrom(Money money) {
    map.clear();
    map.addAll(money.map);
  }
}
