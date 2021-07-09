import 'package:courseplease/models/filters/abstract.dart';

class CityNameFilter extends AbstractFilter {
  final String countryCode;
  final String search;

  CityNameFilter({
    required this.countryCode,
    required this.search,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'countryCode': countryCode,
      'search': search,
    };
  }

  CityNameFilter withSearch(String search) {
    return CityNameFilter(
      countryCode: countryCode,
      search: search,
    );
  }
}
