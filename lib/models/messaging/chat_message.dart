import 'package:courseplease/models/messaging/chat_message_interface.dart';
import '../interfaces.dart';
import 'message_body.dart';

class ChatMessage implements WithId<int>, ChatMessageInterface {
  final int id;
  final int chatId;
  final int? senderUserId;
  final int type;
  final DateTime dateTimeInsert;
  final DateTime? dateTimeEdit;
  DateTime? dateTimeRead;
  final MessageBody body;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderUserId,
    required this.type,
    required this.dateTimeInsert,
    required this.dateTimeEdit,
    required this.dateTimeRead,
    required this.body,
  });

  factory ChatMessage.fromMap(
    Map<String, dynamic> map,
    MessageBody body,
  ) {
    final dateTimeEditString = map['dateTimeEdit'];
    final dateTimeReadString = map['dateTimeRead'];

    return ChatMessage(
      id:             map['id'],
      chatId:         map['chatId'],
      senderUserId:   map['senderUserId'],
      type:           map['type'],
      dateTimeInsert: DateTime.parse(map['dateTimeInsert']),
      dateTimeEdit:   dateTimeEditString == null ? null : DateTime.parse(dateTimeEditString),
      dateTimeRead:   dateTimeReadString == null ? null : DateTime.parse(dateTimeReadString),
      body:           body,
    );
  }
}
