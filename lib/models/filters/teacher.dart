import 'dart:convert';
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

  TeacherFilter({
    required this.subjectId,
    this.formats = const <String>[],
    this.location,
    this.price,
    this.langs = const<String>[],
  });

  String toString() {
    return jsonEncode({'subjectId': subjectId});
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'subjectId':  subjectId,
      'formats':    formats,
      'location':   LocationFilter.fromLocation(location)?.toJson(),
      'price':      price?.toJson(),
      'langs':      langs,
    };
  }
}
