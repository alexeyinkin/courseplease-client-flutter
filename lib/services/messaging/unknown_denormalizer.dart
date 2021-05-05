import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/services/messaging/abstract.dart';

class UnknownMessageBodyDenormalizer extends AbstractMessageBodyDenormalizer {
  @override
  UnknownMessageBody denormalize(int messageType, Map<String, dynamic> map) {
    return UnknownMessageBody();
  }
}
