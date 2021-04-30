import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/messaging/chat_message_interface.dart';
import '../interfaces.dart';
import 'message_body.dart';

class ChatMessage implements WithId<int>, ChatMessageInterface {
  final int id;
  final chatId;
  final int? senderUserId;
  final int type;
  final DateTime dateTimeInsert;
  final DateTime? dateTimeEdit;
  DateTime? dateTimeRead;
  final MessageBody body;
  final Map<String, dynamic> params;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderUserId,
    required this.type,
    required this.dateTimeInsert,
    required this.dateTimeEdit,
    required this.dateTimeRead,
    required this.body,
    required this.params,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
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
      body:           MessageBody.fromMap(map['body']),
      params:         mapOrEmptyListToMap<String, dynamic>(map['params']),
    );
  }

  static ChatMessage? fromMapOrNull(Map<String, dynamic>? map) {
    return map == null ? null : ChatMessage.fromMap(map);
  }
}

class ChatMessageTypeEnum {
  static const content = 1;
  static const purchase = 2;
  static const offerLessonStaticTime = 3;
  static const approveLessonStaticTime = 4;
}
