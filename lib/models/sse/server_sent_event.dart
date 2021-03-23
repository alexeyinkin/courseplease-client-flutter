class ServerSentEvent {
  final int id;
  final int type;
  final DateTime dateTime;
  final Map<String, dynamic>? body;

  ServerSentEvent({
    required this.id,
    required this.type,
    required this.dateTime,
    required this.body,
  });

  factory ServerSentEvent.fromMap(Map<String, dynamic> map) {
    return ServerSentEvent(
      id:       map['id'],
      type:     map['type'],
      dateTime: DateTime.parse(map['dateTime']),
      body:     map['body'],
    );
  }

  static List<ServerSentEvent> fromMaps(List maps) {
    return maps
        .cast<Map<String, dynamic>>()
        .map((map) => ServerSentEvent.fromMap(map))
        .toList()
        .cast<ServerSentEvent>();
  }
}

class SseTypeEnum {
  static const empty = 1;
  static const incomingChatMessage = 2;
  static const outgoingChatMessage = 3;
  static const incomingChatMessageRead = 4;
  static const outgoingChatMessageRead = 5;
}
