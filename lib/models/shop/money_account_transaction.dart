import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/models/money.dart';

class MoneyAccountTransaction implements WithId<int> {
  final int id;
  final DateTime dateTimeInsert;
  final String type;
  final Money money;
  final Money balanceBefore;
  final String description;

  MoneyAccountTransaction({
    required this.id,
    required this.dateTimeInsert,
    required this.type,
    required this.money,
    required this.balanceBefore,
    required this.description,
  });

  factory MoneyAccountTransaction.fromMap(Map<String, dynamic> map) {
    return MoneyAccountTransaction(
      id:             map['id'],
      dateTimeInsert: DateTime.parse(map['dateTimeInsert']),
      type:           map['type'],
      money:          Money.fromMapOrList(map['money']),
      balanceBefore:  Money.fromMapOrList(map['balanceBefore']),
      description:    map['description'],
    );
  }
}
