import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/utils/utils.dart';

class DeliveryFilter extends AbstractFilter {
  final DeliveryViewAs viewAs;
  final DeliveryStatusAlias statusAlias;
  final String productVariantFormatIntName;

  DeliveryFilter({
    required this.viewAs,
    required this.statusAlias,
    required this.productVariantFormatIntName,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'viewAs': enumValueAfterDot(viewAs),
      'statusAlias': enumValueAfterDot(statusAlias),
      'productVariantFormatIntName': productVariantFormatIntName,
    };
  }
}

enum DeliveryViewAs {
  author,
  customer,
}

enum DeliveryStatusAlias {
  toSchedule,
  upcoming,
  toApprove,
  resolved,  // TODO: Split to past and cancelled?
}
