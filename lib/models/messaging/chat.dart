import 'package:courseplease/models/user.dart';
import '../interfaces.dart';
import 'chat_message.dart';

class Chat implements WithId<int> {
  final int id;
  final ChatMessage? lastMessage;
  final int unreadByMeCount;
  final List<User> otherUsers;

  Chat({
    required this.id,
    required this.lastMessage,
    required this.unreadByMeCount,
    required this.otherUsers,
  });

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id:               map['id'],
      lastMessage:      ChatMessage.fromMapOrNull(map['lastMessage']),
      unreadByMeCount:  map['unreadByMeCount'],
      otherUsers:       User.fromMaps(map['otherUsers']),
    );
  }

  Chat withLastIncomingMessage(ChatMessage newMessage) {
    if ((lastMessage?.id ?? 0) >= newMessage.id) return this;

    return Chat(
      id:               id,
      lastMessage:      newMessage,
      unreadByMeCount:  unreadByMeCount + 1,
      otherUsers:       otherUsers,
    );
  }

  Chat withLastOutgoingMessage(ChatMessage newMessage) {
    if ((lastMessage?.id ?? 0) >= newMessage.id) return this;

    return Chat(
      id:               id,
      lastMessage:      newMessage,
      unreadByMeCount:  unreadByMeCount,
      otherUsers:       otherUsers,
    );
  }
}
