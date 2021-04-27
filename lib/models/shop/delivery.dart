import 'package:courseplease/models/location.dart';
import 'package:courseplease/models/product_variant_format_with_price.dart';

import '../interfaces.dart';
import '../user.dart';

class Delivery extends WithId<int> {
  final int id;
  final int status;
  final DateTime? dateTimeStart;
  final DateTime? dateTimeEnd;
  final Location? location;
  final int productSubjectId;
  final ProductVariantFormatWithPrice productVariantFormatWithPrice;
  final User author;

  Delivery({
    required this.id,
    required this.status,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.location,
    required this.productSubjectId,
    required this.productVariantFormatWithPrice,
    required this.author,
  });

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      id:                             map['id'],
      status:                         map['status'],
      dateTimeStart:                  DateTime.tryParse(map['dateTimeStart'] ?? ''),
      dateTimeEnd:                    DateTime.tryParse(map['dateTimeEnd'] ?? ''),
      location:                       Location.fromMapOrNull(map['location']),
      productSubjectId:               map['productSubjectId'],
      productVariantFormatWithPrice:  ProductVariantFormatWithPrice.fromMap(map['productVariantFormatWithPrice']),
      author:                         User.fromMap(map['author']),
    );
  }
}
