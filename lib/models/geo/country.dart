import 'package:courseplease/models/interfaces.dart';

class Country extends WithIdTitle<String> {
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
