import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/filters/location.dart';
import 'package:courseplease/models/location.dart';
import 'package:courseplease/models/shop/price_range.dart';

class GalleryImageFilter extends AbstractFilter {
  final int? subjectId;
  final int? teacherId;
  final int purposeId;
  final List<String> formats;
  final Location? location;
  final PriceRange? price;
  final List<String> langs;

  GalleryImageFilter({
    required this.subjectId,
    this.teacherId,
    required this.purposeId,
    this.formats = const <String>[],
    this.location,
    this.price,
    this.langs = const<String>[],
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'subjectId':  subjectId,
      'teacherId':  teacherId,
      'purposeId':  purposeId,
      'formats':    formats,
      'location':   LocationFilter.fromLocation(location)?.toJson(),
      'price':      price?.toJson(),
      'langs':      langs,
    };
  }
}
