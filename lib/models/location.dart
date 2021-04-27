import 'package:courseplease/models/subway_station.dart';

class Location {
  final double latitude;
  final double longitude;
  final String countryCode;
  final String city;
  final String publicLine;
  final List<SubwayStation> subwayStations;

  Location({
    required this.latitude,
    required this.longitude,
    required this.countryCode,
    required this.city,
    required this.publicLine,
    required this.subwayStations,
  });

  factory Location.from(Location location) {
    return Location(
      latitude:       location.latitude,
      longitude:      location.longitude,
      countryCode:    location.countryCode,
      city:           location.city,
      publicLine:     location.publicLine,
      subwayStations: List<SubwayStation>.from(location.subwayStations),
    );
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    List<SubwayStation> subwayStations = map['subwayStations']
        .map((map) => SubwayStation.fromMap(map))
        .toList()
        .cast<SubwayStation>();

    return Location(
      latitude:       map['latitude'].toDouble(),
      longitude:      map['longitude'].toDouble(),
      countryCode:    map['countryCode'],
      city:           map['city'],
      publicLine:     map['publicLine'],
      subwayStations: subwayStations,
    );
  }

  static Location? fromMapOrNull(Map<String, dynamic>? map) {
    return map == null
        ? null
        : Location.fromMap(map);
  }
}
