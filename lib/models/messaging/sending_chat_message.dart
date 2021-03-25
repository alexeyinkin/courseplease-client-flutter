import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/widgets/messaging/chat_message_interface.dart';

class SendingChatMessage implements ChatMessageInterface {
  final int senderUserId;
  final int? recipientChatId;
  final int? recipientUserId;
  final MessageBody body;
  final String uuid;
  SendingChatMessageStatus status;

  SendingChatMessage({
    required this.senderUserId,
    required this.recipientChatId,
    required this.recipientUserId,
    required this.body,
    required this.uuid,
    required this.status,
  });
}

enum SendingChatMessageStatus {
  fresh,
  sending,
  sent,
  failed,
}
