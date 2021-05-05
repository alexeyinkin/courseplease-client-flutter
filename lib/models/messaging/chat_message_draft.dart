import 'package:courseplease/models/messaging/message_body.dart';

class ChatMessageDraft {
  final int? recipientChatId;
  final int? recipientUserId;
  final MessageBody body;

  ChatMessageDraft({
    required this.recipientChatId,
    required this.recipientUserId,
    required this.body,
  });

  factory ChatMessageDraft.fromMap(Map<String, dynamic> map) {
    return ChatMessageDraft(
      recipientChatId:  map['recipientChatId'],
      recipientUserId:  map['recipientUserId'],
      body:             ContentMessageBody.fromMap(map['body']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipientChatId':  recipientChatId,
      'recipientUserId':  recipientUserId,
      'body':             body,
    };
  }
}
