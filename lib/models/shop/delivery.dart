import 'package:courseplease/models/location.dart';
import 'package:courseplease/models/product_variant_format_with_price.dart';
import 'package:courseplease/models/shop/review.dart';

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
  final bool reviewedBySeller;
  final bool reviewedByCustomer;
  final Review? reviewBySeller;
  final Review? reviewByCustomer;
  final bool sellerCanReview;
  final bool customerCanReview;
  final User seller;
  final User customer;

  Delivery({
    required this.id,
    required this.status,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.location,
    required this.productSubjectId,
    required this.productVariantFormatWithPrice,
    required this.reviewedBySeller,
    required this.reviewedByCustomer,
    required this.reviewBySeller,
    required this.reviewByCustomer,
    required this.sellerCanReview,
    required this.customerCanReview,
    required this.seller,
    required this.customer,
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
      reviewedBySeller:               map['reviewedBySeller'],
      reviewedByCustomer:             map['reviewedByCustomer'],
      reviewBySeller:                 Review.fromMapOrNull(map['reviewBySeller']),
      reviewByCustomer:               Review.fromMapOrNull(map['reviewByCustomer']),
      sellerCanReview:                map['sellerCanReview'],
      customerCanReview:              map['customerCanReview'],
      seller:                         User.fromMap(map['seller']),
      customer:                       User.fromMap(map['customer']),
    );
  }
}
