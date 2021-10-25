import 'package:courseplease/models/user.dart';
import 'package:courseplease/services/messaging/chat_message_denormalizer.dart';
import 'package:get_it/get_it.dart';
import 'package:model_interfaces/model_interfaces.dart';
import 'chat_message.dart';

class Chat implements WithId<int> {
  final int id;
  final ChatMessage? lastMessage;
  int unreadByMeCount;
  final List<User> otherUsers;
  final messageIdsMarkedAsRead = <int, void>{};

  Chat({
    required this.id,
    required this.lastMessage,
    required this.unreadByMeCount,
    required this.otherUsers,
  });

  factory Chat.fromMap(Map<String, dynamic> map) {
    final denormalizer = GetIt.instance.get<ChatMessageDenormalizer>();

    return Chat(
      id:               map['id'],
      lastMessage:      denormalizer.denormalizeMapOrNull(map['lastMessage']),
      unreadByMeCount:  map['unreadByMeCount'],
      otherUsers:       User.fromMaps(map['otherUsers']),
    );
  }

  Chat withLastMessage(ChatMessage editedMessage) {
    return Chat(
      id:               id,
      lastMessage:      editedMessage,
      unreadByMeCount:  unreadByMeCount,
      otherUsers:       otherUsers,
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
