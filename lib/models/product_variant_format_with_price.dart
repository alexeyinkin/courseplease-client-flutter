import 'money.dart';

class ProductVariantFormatWithPrice {
  /// Null when creating a format. Always non-null when shopping.
  final int? productVariantId;

  final String intName;
  final String title;
  bool enabled;
  final Money? minPrice;
  final Money? maxPrice;

  ProductVariantFormatWithPrice({
    required this.productVariantId,
    required this.intName,
    required this.title,
    required this.enabled,
    required this.minPrice,
    required this.maxPrice,
  });

  factory ProductVariantFormatWithPrice.fromMap(Map<String, dynamic> map) {
    return ProductVariantFormatWithPrice(
      productVariantId: map['productVariantId'],
      intName:          map['intName'],
      title:            map['title'],
      enabled:          map['enabled'],
      minPrice:         Money.fromMapOrListOrNull(map['minPrice']),
      maxPrice:         Money.fromMapOrListOrNull(map['maxPrice']),
    );
  }

  factory ProductVariantFormatWithPrice.from(ProductVariantFormatWithPrice obj) {
    return ProductVariantFormatWithPrice(
      productVariantId: obj.productVariantId,
      intName:          obj.intName,
      title:            obj.title,
      enabled:          obj.enabled,
      minPrice:         obj.minPrice,
      maxPrice:         obj.maxPrice,
    );
  }
}
