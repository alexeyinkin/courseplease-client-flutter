/// Used both for received messages and for sending.
class MessageBody {
  final String text;

  MessageBody({
    required this.text,
  });

  factory MessageBody.fromMap(Map<String, dynamic> map) {
    return MessageBody(
      text: map['text'],
    );
  }

  // Extract this if received and sending objects classes are split.
  // This is only required for sending.
  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}
