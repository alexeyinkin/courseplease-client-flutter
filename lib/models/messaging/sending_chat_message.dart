import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/utils/utils.dart';
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

  factory SendingChatMessage.fromMap(Map<String, dynamic> map) {
    final status = enumValueByString(
      SendingChatMessageStatus.values,
      map['status'],
      null,
    );

    if (status == null) {
      throw Exception('Message persisted in an older version of the app.');
    }

    return SendingChatMessage(
      senderUserId:     map['senderUserId'],
      recipientChatId:  map['recipientChatId'],
      recipientUserId:  map['recipientUserId'],
      body:             MessageBody.fromMap(map['body']),
      uuid:             map['uuid'],
      status:           status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderUserId':     senderUserId,
      'recipientChatId':  recipientChatId,
      'recipientUserId':  recipientUserId,
      'body':             body,
      'uuid':             uuid,
      'status':           enumValueAfterDot(status),
    };
  }
}

enum SendingChatMessageStatus {
  readyToSend,
  sending,
  sent,
  failed,
}
