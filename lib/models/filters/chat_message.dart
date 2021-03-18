import 'package:courseplease/models/filters/abstract.dart';

class ChatMessageFilter extends AbstractFilter {
  final int chatId;

  ChatMessageFilter({
    required this.chatId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
    };
  }
}
