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
}
