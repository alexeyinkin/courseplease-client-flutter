import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/models/money.dart';

class WithdrawOrder extends WithId<int> {
  final int id;
  final int moneyAccountId;
  final int withdrawAccountId;
  final Money money;
  final int status;
  final DateTime dateTimeInsert;
  final DateTime? dateTimeSent;

  WithdrawOrder({
    required this.id,
    required this.moneyAccountId,
    required this.withdrawAccountId,
    required this.money,
    required this.status,
    required this.dateTimeInsert,
    required this.dateTimeSent,
  });

  factory WithdrawOrder.fromMap(Map<String, dynamic> map) {
    return WithdrawOrder(
      id:                 map['id'],
      moneyAccountId:     map['moneyAccountId'],
      withdrawAccountId:  map['withdrawAccountId'],
      money:              Money.fromMapOrList(map['money']),
      status:             map['status'],
      dateTimeInsert:     DateTime.parse(map['dateTimeInsert']),
      dateTimeSent:       DateTime.tryParse(map['dateTimeSent'] ?? ''),
    );
  }
}
