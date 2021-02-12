import 'package:meta/meta.dart';
import 'product_variant_format_with_price.dart';

class TeacherSubject {
  final int subjectId;
  final String body;
  final List<ProductVariantFormatWithPrice> productVariantFormats;

  TeacherSubject({
    @required this.subjectId,
    @required this.body,
    @required this.productVariantFormats,
  });

  factory TeacherSubject.fromMap(Map<String, dynamic> map) {
    var productVariantFormats = map['productVariantFormats']
        .map((map) => ProductVariantFormatWithPrice.fromMap(map))
        .toList()
        .cast<ProductVariantFormatWithPrice>();

    return TeacherSubject(
      subjectId:              map['subjectId'],
      body:                   map['body'],
      productVariantFormats:  productVariantFormats,
    );
  }

  static List<TeacherSubject> fromMaps(List maps) {
    return maps
        .cast<Map<String, dynamic>>()
        .map((map) => TeacherSubject.fromMap(map))
        .toList()
        .cast<TeacherSubject>();
  }

  static List<int> getSubjectIds(List<TeacherSubject> subjects) {
    final ids = <int>[];
    for (final subject in subjects) {
      ids.add(subject.subjectId);
    }
    return ids;
  }
}
