import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:get_it/get_it.dart';

import 'message_body_denormalizer_locator.dart';

class ChatMessageDenormalizer {
  final _denormalizerLocator = GetIt.instance.get<MessageBodyDenormalizerLocator>();

  ChatMessage? denormalizeMapOrNull(Map<String, dynamic>? map) {
    return map == null
        ? null
        : denormalize(map);
  }

  ChatMessage denormalize(Map<String, dynamic> map) {
    final body = _denormalizeBody(map);
    return ChatMessage.fromMap(map, body);
  }

  MessageBody _denormalizeBody(Map<String, dynamic> map) {
    final type = map['type'];
    final bodyMap = map['body'];

    final denormalizer = _denormalizerLocator.get(type);

    return denormalizer.denormalize(
      type,
      mapOrEmptyListToMap<String, dynamic>(bodyMap),
    );
  }
}
