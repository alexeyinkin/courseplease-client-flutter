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
}
