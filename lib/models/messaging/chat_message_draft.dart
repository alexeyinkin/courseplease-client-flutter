import 'package:courseplease/models/messaging/message_body.dart';

class ChatMessageDraft {
  final int? chatId;
  final int? recipientUserId;
  final MessageBody body;

  ChatMessageDraft({
    required this.chatId,
    required this.recipientUserId,
    required this.body,
  });

  factory ChatMessageDraft.fromMap(Map<String, dynamic> map) {
    return ChatMessageDraft(
      chatId:           map['chatId'],
      recipientUserId:  map['recipientUserId'],
      body:             ContentMessageBody.fromMap(map['body']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId':           chatId,
      'recipientUserId':  recipientUserId,
      'body':             body,
    };
  }
}
