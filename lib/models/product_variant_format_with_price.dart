import 'package:meta/meta.dart';
import 'money.dart';

class ProductVariantFormatWithPrice {
  final String intName;
  final String title;
  final Money minPrice; // Nullable
  final Money maxPrice; // Nullable

  ProductVariantFormatWithPrice({
    @required this.intName,
    @required this.title,
    @required this.minPrice,
    @required this.maxPrice,
  });

  factory ProductVariantFormatWithPrice.fromMap(Map<String, dynamic> map) {
    return ProductVariantFormatWithPrice(
      intName:  map['intName'],
      title:    map['title'],
      minPrice: map['minPrice'] == null ? null : Money.fromMapOrList(map['minPrice']),
      maxPrice: map['maxPrice'] == null ? null : Money.fromMapOrList(map['maxPrice']),
    );
  }
}
