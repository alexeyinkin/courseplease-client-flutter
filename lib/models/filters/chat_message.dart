import 'package:courseplease/models/filters/abstract.dart';
import 'package:meta/meta.dart';

class ChatMessageFilter extends AbstractFilter {
  final int chatId;

  ChatMessageFilter({
    @required this.chatId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
    };
  }
}
