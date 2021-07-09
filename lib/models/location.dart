import 'package:courseplease/models/subway_station.dart';

class Location {
  final double latitude;
  final double longitude;
  final String countryCode;
  final int? cityId;
  final String cityTitle;
  final String streetAddress;
  final String publicLine;
  final String privacy;
  final List<SubwayStation> subwayStations;

  Location({
    required this.latitude,
    required this.longitude,
    required this.countryCode,
    required this.cityId,
    required this.cityTitle,
    required this.streetAddress,
    required this.publicLine,
    required this.privacy,
    required this.subwayStations,
  });

  factory Location.from(Location location) {
    return Location(
      latitude:       location.latitude,
      longitude:      location.longitude,
      countryCode:    location.countryCode,
      cityId:         location.cityId,
      cityTitle:      location.cityTitle,
      streetAddress:  location.streetAddress,
      publicLine:     location.publicLine,
      privacy:        location.privacy,
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
      cityId:         map['cityId'],
      cityTitle:      map['cityTitle'],
      streetAddress:  map['streetAddress'],
      publicLine:     map['publicLine'],
      privacy:        map['privacy'],
      subwayStations: subwayStations,
    );
  }

  static Location? fromMapOrNull(Map<String, dynamic>? map) {
    return map == null
        ? null
        : Location.fromMap(map);
  }
}
