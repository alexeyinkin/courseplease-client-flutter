import 'package:courseplease/models/messaging/refund_request_message_body.dart';
import 'package:courseplease/services/messaging/abstract.dart';

class RefundRequestMessageBodyDenormalizer extends AbstractMessageBodyDenormalizer {
  @override
  RefundRequestMessageBody denormalize(int type, Map<String, dynamic> map) {
    return RefundRequestMessageBody.fromMap(map);
  }
}
