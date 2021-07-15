import '../interfaces.dart';

class Comment extends WithId<int> {
  final int id;
  final String text;
  final DateTime dateTimeInsert;
  final int authorId;

  Comment({
    required this.id,
    required this.text,
    required this.dateTimeInsert,
    required this.authorId,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id:             map['id'],
      text:           map['text'],
      dateTimeInsert: DateTime.parse(map['dateTimeInsert']),
      authorId:       map['authorId'],
    );
  }
}
