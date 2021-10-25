import 'package:model_interfaces/model_interfaces.dart';

class Country implements WithIdTitle<String> {
  final String id;
  final String title;

  Country({
    required this.id,
    required this.title,
  });

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['countryCode'],
      title: map['title'],
    );
  }
}
