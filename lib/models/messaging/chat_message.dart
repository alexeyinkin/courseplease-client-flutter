import 'package:courseplease/widgets/messaging/chat_message_interface.dart';
import '../interfaces.dart';
import 'message_body.dart';

class ChatMessage implements WithId<int>, ChatMessageInterface {
  final int id;
  final chatId;
  final int? senderUserId;
  final DateTime dateTimeInsert;
  final DateTime? dateTimeEdit;
  final DateTime? dateTimeRead;
  final MessageBody body;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderUserId,
    required this.dateTimeInsert,
    required this.dateTimeEdit,
    required this.dateTimeRead,
    required this.body,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final dateTimeEditString = map['dateTimeEdit'];
    final dateTimeReadString = map['dateTimeEdit'];

    return ChatMessage(
      id:             map['id'],
      chatId:         map['chatId'],
      senderUserId:   map['senderUserId'],
      dateTimeInsert: DateTime.parse(map['dateTimeInsert']),
      dateTimeEdit:   dateTimeEditString == null ? null : DateTime.parse(dateTimeEditString),
      dateTimeRead:   dateTimeReadString == null ? null : DateTime.parse(dateTimeReadString),
      body:           MessageBody.fromMap(map['body']),
    );
  }

  static ChatMessage? fromMapOrNull(Map<String, dynamic>? map) {
    return map == null ? null : ChatMessage.fromMap(map);
  }
}
