import 'package:meta/meta.dart';

import '../interfaces.dart';
import 'message_body.dart';

class ChatMessage extends WithId<int> {
  final int id;
  final int senderUserId; // Nullable
  final DateTime dateTimeInsert;
  final DateTime dateTimeEdit; // Nullable
  final DateTime dateTimeRead; // Nullable
  final MessageBody body;

  ChatMessage({
    @required this.id,
    @required this.senderUserId,
    @required this.dateTimeInsert,
    @required this.dateTimeEdit,
    @required this.dateTimeRead,
    @required this.body,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final dateTimeEditString = map['dateTimeEdit'];
    final dateTimeReadString = map['dateTimeEdit'];

    return ChatMessage(
      id:             map['id'],
      senderUserId:   map['senderUserId'],
      dateTimeInsert: DateTime.parse(map['dateTimeInsert']),
      dateTimeEdit:   dateTimeEditString == null ? null : DateTime.parse(dateTimeEditString),
      dateTimeRead:   dateTimeReadString == null ? null : DateTime.parse(dateTimeReadString),
      body:           MessageBody.fromMap(map['body']),
    );
  }

  static ChatMessage fromMapOrNull(Map<String, dynamic> map) { // Nullable, Nullable
    return map == null ? null : ChatMessage.fromMap(map);
  }
}
