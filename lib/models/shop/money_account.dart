import '../money.dart';

class MoneyAccount {
  final String cur;
  final Money balance;

  MoneyAccount({
    required this.cur,
    required this.balance,
  });

  factory MoneyAccount.fromMap(Map<String, dynamic> map) {
    return MoneyAccount(
      cur:      map['cur'],
      balance:  Money.fromMapOrList(map['money']),
    );
  }

  static List<MoneyAccount> fromMaps(List maps) {
    return maps
        .cast<Map<String, dynamic>>()
        .map((map) => MoneyAccount.fromMap(map))
        .toList()
        .cast<MoneyAccount>();
  }

  factory MoneyAccount.from(MoneyAccount another) {
    return MoneyAccount(
      cur: another.cur,
      balance: Money.from(another.balance),
    );
  }

  static List<MoneyAccount> cloneList(List<MoneyAccount> accounts) {
    final result = <MoneyAccount>[];
    for (final account in accounts) {
      result.add(MoneyAccount.from(account));
    }
    return result;
  }

  static List<MoneyAccount> pickAllByCur(List<MoneyAccount> accounts, String cur) {
    final result = <MoneyAccount>[];
    for (final account in accounts) {
      if (account.cur == cur) result.add(account);
    }
    return result;
  }

  static Money getSumByCur(List<MoneyAccount> accounts, String cur) {
    final result = Money.zero();

    for (final account in accounts) {
      if (account.cur == cur) result.addMoney(account.balance);
    }

    return result;
  }

  static Money getSum(List<MoneyAccount> accounts) {
    final result = Money.zero();

    for (final account in accounts) {
      result.addMoney(account.balance);
    }

    return result;
  }
}
