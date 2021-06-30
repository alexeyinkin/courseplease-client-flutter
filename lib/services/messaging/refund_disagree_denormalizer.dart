import 'package:courseplease/models/messaging/refund_disagree_message_body.dart';
import 'package:courseplease/services/messaging/abstract.dart';

class RefundDisagreeMessageBodyDenormalizer extends AbstractMessageBodyDenormalizer {
  @override
  RefundDisagreeMessageBody denormalize(int type, Map<String, dynamic> map) {
    return RefundDisagreeMessageBody();
  }
}
