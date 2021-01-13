import 'package:meta/meta.dart';

class ProductVariantFormat {
  final String title;

  ProductVariantFormat({
    @required this.title,
  });

  factory ProductVariantFormat.fromMap(Map<String, dynamic> map) {
    return ProductVariantFormat(
      title:  map['title'],
    );
  }
}
