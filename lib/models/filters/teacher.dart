import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/filters/location.dart';
import 'package:courseplease/models/location.dart';
import 'package:courseplease/models/shop/price_range.dart';

class TeacherFilter extends AbstractFilter {
  final int? subjectId;
  final List<String> formats;
  final Location? location;
  final PriceRange? price;
  final List<String> langs;
  final String? search;

  TeacherFilter({
    required this.subjectId,
    this.formats = const <String>[],
    this.location,
    this.price,
    this.langs = const<String>[],
    this.search,
  });

  TeacherFilter withSearch(String? search) {
    return TeacherFilter(
      subjectId:  subjectId,
      formats:    formats,
      location:   location,
      price:      price,
      langs:      langs,
      search:     search,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'subjectId':  subjectId,
      'formats':    formats,
      'location':   LocationFilter.fromLocation(location)?.toJson(),
      'price':      price?.toJson(),
      'langs':      langs,
      'search':     search,
    };
  }
}
