import 'package:courseplease/models/messaging/refund_agree_message_body.dart';
import 'package:courseplease/services/messaging/abstract.dart';

class RefundAgreeMessageBodyDenormalizer extends AbstractMessageBodyDenormalizer {
  @override
  RefundAgreeMessageBody denormalize(int type, Map<String, dynamic> map) {
    return RefundAgreeMessageBody();
  }
}
