import 'package:courseplease/models/filters/delivery.dart';
import 'package:courseplease/models/product_variant_format.dart';
import 'package:courseplease/widgets/shop/delivery_list.dart';
import 'package:flutter/material.dart';

class TeachingLessonsResolvedTabWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DeliveryListWidget(
      filter: DeliveryFilter(
        viewAs: DeliveryViewAs.seller,
        statusAlias: DeliveryStatusAlias.resolved,
        productVariantFormatIntName: ProductVariantFormatIntNameEnum.consulting,
      ),
    );
  }
}
