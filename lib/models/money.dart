import 'package:courseplease/models/shop/enum/currency_alpha3.dart';
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

  static Money? fromMapOrListOrNull(dynamic? mapOrEmptyList) {
    if (mapOrEmptyList == null) return null;
    return Money.fromMapOrList(mapOrEmptyList);
  }

  factory Money.from(Money another) {
    return Money(
      Map<String, double>.from(another.map),
    );
  }

  factory Money.zero() {
    return Money(Map<String, double>());
  }

  factory Money.singleCurrency(String cur, double value) {
    return Money({cur: value});
  }

  factory Money.fromNullableMap(Map<String?, double?> nullableMap) {
    final map = Map<String, double>();

    for (final entry in nullableMap.entries) {
      if (entry.key == null || entry.value == null) continue;
      map[entry.key!] = entry.value!;
    }

    return Money(map);
  }

  @override
  String toString({bool plusForPositive = false}) {
    final parts = <String>[];

    for (final entry in map.entries) {
      parts.add(
        formatMoneyValue(entry.value, plusForPositive: plusForPositive) + ' ' + curToSymbol(entry.key),
      );
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
    if (map.length > 1) throw Exception('Cannot convert currencies.');

    for (final value in map.values) {
      return value > 0;
    }
    return false;
  }

  bool isNegative() {
    // TODO: Convert. Now following the backend incomplete method.
    if (map.length > 1) throw Exception('Cannot convert currencies.');

    for (final value in map.values) {
      return value < 0;
    }
    return false;
  }

  static String curToSymbol(String cur) {
    switch (cur) {
      case CurrencyAlpha3Enum.USD: return '\$';
      case CurrencyAlpha3Enum.EUR: return '€';
      case CurrencyAlpha3Enum.RUB: return '₽';
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

  void addMoney(Money money) {
    for (final entry in money.map.entries) {
      map[entry.key] = (map[entry.key] ?? 0) + entry.value;
    }
  }

  Money plus(Money money) {
    final result = Money.from(this);
    result.addMoney(money);
    return result;
  }

  void subtractMoney(Money money) {
    addMoney(money.times(-1));
  }

  Money minus(Money money) {
    return plus(money.times(-1));
  }

  Money times(double multiplier) {
    final result = Money.zero();

    for (final entry in map.entries) {
      result.map[entry.key] = entry.value * multiplier;
    }

    return result;
  }

  static Money? pickByCur(List<Money> list, String cur) {
    for (final money in list) {
      if (money.map.containsKey(cur)) {
        return money;
      }
    }
    return null;
  }

  int getCurCount() {
    return map.length;
  }

  static Money? min(List<Money> list) {
    Money? result;

    for (final money in list) {
      if (result == null || money.lt(result)) {
        result = money;
      }
    }

    return result == null ? null : Money.from(result);
  }

  static Money? max(List<Money> list) {
    Money? result;

    for (final money in list) {
      if (result == null || money.gt(result)) {
        result = money;
      }
    }

    return result == null ? null : Money.from(result);
  }

  bool gt(Money money) {
    if (money.isZero()) return isPositive();
    if (isZero()) return money.isNegative();

    for (final entry in map.entries) {
      final otherValue = money.map[entry.key];

      if (otherValue == null) {
        throw Exception('Cannot convert currencies comparing ' + toString() + ' and ' + money.toString());
      }

      return entry.value > otherValue;
    }

    throw Exception('Never get here.');
  }

  bool lt(Money money) {
    if (money.isZero()) return isNegative();
    if (isZero()) return money.isPositive();

    for (final entry in map.entries) {
      final otherValue = money.map[entry.key];

      if (otherValue == null) {
        throw Exception('Cannot convert currencies comparing ' + toString() + ' and ' + money.toString());
      }

      return entry.value < otherValue;
    }

    throw Exception('Never get here.');
  }

  Map<String, Money> splitByCurs() {
    final result = <String, Money>{};

    for (final entry in map.entries) {
      result[entry.key] = Money(Map.fromEntries([entry]));
    }

    return result;
  }
}
