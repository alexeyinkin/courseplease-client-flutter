import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/utils/utils.dart';

class DeliveryFilter extends AbstractFilter {
  final DeliveryStatusAlias statusAlias;
  final String productVariantFormatIntName;

  DeliveryFilter({
    required this.statusAlias,
    required this.productVariantFormatIntName,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'statusAlias': enumValueAfterDot(statusAlias),
      'productVariantFormatIntName': productVariantFormatIntName,
    };
  }
}

enum DeliveryStatusAlias {
  toSchedule,
  upcoming,
  toApprove,
  resolved,  // TODO: Split to past and cancelled?
}
