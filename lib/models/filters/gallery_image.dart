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
    final result = <String, dynamic>{};

    if (subjectId != null)  result['subjectId'] = subjectId;
    if (teacherId != null)  result['teacherId'] = teacherId;
    result['purposeId'] = purposeId;
    if (formats.isNotEmpty) result['formats'] = formats;
    if (location != null)   result['location'] = LocationFilter.fromLocation(location)?.toJson();
    if (price != null)      result['price'] = price?.toJson();
    if (langs.isNotEmpty)   result['langs'] = langs;

    return result;
  }

  Map<String, dynamic> toJsonWithoutSubjectAndPurpose() {
    final result = toJson();

    result.remove('subjectId');
    result.remove('purposeId');

    return result;
  }
}
