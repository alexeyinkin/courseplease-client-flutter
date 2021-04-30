import 'package:courseplease/models/product_variant_format_with_price.dart';

import '../user.dart';

class LineItem {
  final int productVariantId;
  final int productSubjectId;
  final ProductVariantFormatWithPrice format;
  final User user;
  final int quantity;

  LineItem({
    required this.productVariantId,
    required this.productSubjectId,
    required this.format,
    required this.user,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productVariantId': productVariantId,
      'quantity':         quantity,
    };
  }
}
