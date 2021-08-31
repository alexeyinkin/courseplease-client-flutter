import 'abstract.dart';
import 'package:courseplease/models/location.dart';

class GalleryImageFilter extends AbstractFilter {
  final int? subjectId;
  final int? teacherId;
  final int purposeId;
  final List<String> formats;
  final Location? location;
  final double? priceFrom;
  final double? priceTo;
  final String? cur;

  GalleryImageFilter({
    required this.subjectId,
    this.teacherId,
    required this.purposeId,
    this.formats = const <String>[],
    this.location,
    this.priceFrom,
    this.priceTo,
    this.cur,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'subjectId':  subjectId,
      'teacherId':  teacherId,
      'purposeId':  purposeId,
      'formats':    formats,
      'location':   location?.toJson(),
      'priceFrom':  priceFrom,
      'priceTo':    priceTo,
      'cur':        cur,
    };
  }
}
