import 'package:courseplease/models/map_property.dart';
import 'package:model_interfaces/model_interfaces.dart';

class WithdrawService implements WithIdTitle<int> {
  final int id;
  final String title;
  final List<MapProperty> properties;

  WithdrawService({
    required this.id,
    required this.title,
    required this.properties,
  });

  factory WithdrawService.fromMap(Map<String, dynamic> map) {
    return WithdrawService(
      id:         map['id'],
      title:      map['title'],
      properties: MapProperty.fromMaps(map['properties']['properties']),
    );
  }
}
