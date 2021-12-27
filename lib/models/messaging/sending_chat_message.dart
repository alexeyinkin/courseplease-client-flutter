import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/models/messaging/chat_message_interface.dart';

class SendingChatMessage implements ChatMessageInterface {
  final int chatId;
  final int senderUserId;
  final int type;
  final MessageBody body;
  final String uuid;
  SendingChatMessageStatus status;

  SendingChatMessage({
    required this.chatId,
    required this.senderUserId,
    required this.type,
    required this.body,
    required this.uuid,
    required this.status,
  });

  factory SendingChatMessage.fromMap(Map<String, dynamic> map) {
    try {
      final status = SendingChatMessageStatus.values.byName(map['status']);

      return SendingChatMessage(
        chatId:           map['chatId'],
        senderUserId:     map['senderUserId'],
        type:             map['type'] ?? 1,
        body:             ContentMessageBody.fromMap(map['body']),
        uuid:             map['uuid'],
        status:           status,
      );
    } catch (ex) {
      throw Exception('Message persisted in an older version of the app.');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId':       chatId,
      'senderUserId': senderUserId,
      'body':         body,
      'uuid':         uuid,
      'status':       status.name,
    };
  }
}

enum SendingChatMessageStatus {
  readyToSend,
  sending,
  sent,
  failed,
}
