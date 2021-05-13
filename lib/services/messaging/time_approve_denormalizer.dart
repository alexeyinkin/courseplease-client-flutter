import 'package:courseplease/models/messaging/time_approve_message_body.dart';
import 'package:courseplease/services/messaging/abstract.dart';

class TimeApproveMessageBodyDenormalizer extends AbstractMessageBodyDenormalizer {
  @override
  TimeApproveMessageBody denormalize(int type, Map<String, dynamic> map) {
    return TimeApproveMessageBody.fromMap(map);
  }
}
