import 'package:courseplease/utils/utils.dart';
import 'package:model_interfaces/model_interfaces.dart';

class WithdrawAccount implements WithIdTitle<int> {
  final int id;
  final int serviceId;
  final String title;
  final String number;
  final Map<String, String> properties;

  WithdrawAccount({
    required this.id,
    required this.serviceId,
    required this.title,
    required this.number,
    required this.properties,
  });

  factory WithdrawAccount.fromMap(Map<String, dynamic> map) {
    return WithdrawAccount(
      id:         map['id'],
      serviceId:  map['serviceId'],
      title:      map['title'],
      number:     map['number'],
      properties: toStringStringMap(map['properties']),
    );
  }
}
