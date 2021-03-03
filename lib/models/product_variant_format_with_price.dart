import 'package:meta/meta.dart';
import 'money.dart';

class ProductVariantFormatWithPrice {
  final String intName;
  final String title;
  bool enabled;
  final Money minPrice; // Nullable
  final Money maxPrice; // Nullable

  ProductVariantFormatWithPrice({
    @required this.intName,
    @required this.title,
    @required this.enabled,
    @required this.minPrice,
    @required this.maxPrice,
  });

  factory ProductVariantFormatWithPrice.fromMap(Map<String, dynamic> map) {
    return ProductVariantFormatWithPrice(
      intName:  map['intName'],
      title:    map['title'],
      enabled:  map['enabled'],
      minPrice: map['minPrice'] == null ? null : Money.fromMapOrList(map['minPrice']),
      maxPrice: map['maxPrice'] == null ? null : Money.fromMapOrList(map['maxPrice']),
    );
  }

  factory ProductVariantFormatWithPrice.from(ProductVariantFormatWithPrice obj) {
    return ProductVariantFormatWithPrice(
      intName:  obj.intName,
      title:    obj.title,
      enabled:  obj.enabled,
      minPrice: obj.minPrice,
      maxPrice: obj.maxPrice,
    );
  }
}
