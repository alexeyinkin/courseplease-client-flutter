import 'package:courseplease/models/messaging/message_body.dart';

abstract class AbstractMessageBodyDenormalizer {
  MessageBody denormalize(int messageType, Map<String, dynamic> map);
}
