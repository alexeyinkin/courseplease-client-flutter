import 'package:courseplease/models/messaging/message_body.dart';

abstract class ChatMessageInterface {
  int? get senderUserId;
  MessageBody get body;
}
