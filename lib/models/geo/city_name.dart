import 'package:model_interfaces/model_interfaces.dart';

class CityName implements WithIdTitle<int> {
  final int id;
  final int cityId;
  final String title;

  CityName({
    required this.id,
    required this.cityId,
    required this.title,
  });

  factory CityName.fromMap(Map<String, dynamic> map) {
    return CityName(
      id: map['id'],
      cityId: map['cityId'],
      title: map['title'],
    );
  }

  factory CityName.fromCityIdAndTitle(int cityId, String title) {
    return CityName(
      id: 0,
      cityId: cityId,
      title: title,
    );
  }
}
