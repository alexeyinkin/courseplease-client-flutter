import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/services/messaging/abstract.dart';

class ContentMessageBodyDenormalizer extends AbstractMessageBodyDenormalizer {
  @override
  ContentMessageBody denormalize(int type, Map<String, dynamic> map) {
    return ContentMessageBody.fromMap(map);
  }
}
