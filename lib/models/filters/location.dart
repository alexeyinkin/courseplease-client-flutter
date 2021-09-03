import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/location.dart';

class LocationFilter extends AbstractFilter {
  final String countryCode;
  final int? cityId;

  LocationFilter({
    required this.countryCode,
    this.cityId,
  });

  static LocationFilter? fromLocation(Location? location) {
    if (location == null) return null;

    return LocationFilter(
      countryCode:  location.countryCode,
      cityId:       location.cityId,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'countryCode':  countryCode,
      'cityId':       cityId,
    };
  }
}
