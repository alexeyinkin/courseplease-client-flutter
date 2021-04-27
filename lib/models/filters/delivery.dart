import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/utils/utils.dart';

class DeliveryFilter extends AbstractFilter {
  final DeliveryStatusAlias statusAlias;

  DeliveryFilter({
    required this.statusAlias,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'statusAlias': enumValueAfterDot(statusAlias),
    };
  }
}

enum DeliveryStatusAlias {
  toSchedule,
  upcoming,
  toApprove,
  resolved,  // TODO: Split to past and cancelled?
}
