import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/filters/location.dart';
import 'package:courseplease/models/filters/price.dart';
import 'package:courseplease/models/location.dart';

class GalleryImageFilter extends AbstractFilter {
  final int? subjectId;
  final int? teacherId;
  final int purposeId;
  final List<String> formats;
  final Location? location;
  final PriceFilter? price;

  GalleryImageFilter({
    required this.subjectId,
    this.teacherId,
    required this.purposeId,
    this.formats = const <String>[],
    this.location,
    this.price,
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
    };
  }
}
