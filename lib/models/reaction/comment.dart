import 'package:model_interfaces/model_interfaces.dart';
import 'likable.dart';

class Comment implements WithId<int>, Likable {
  final int id;
  final String text;
  final DateTime dateTimeInsert;
  final int authorId;
  final int likeCount;
  final bool isLiked;
  final int loadTimestampMilliseconds;

  Comment({
    required this.id,
    required this.text,
    required this.dateTimeInsert,
    required this.authorId,
    required this.likeCount,
    required this.isLiked,
    required this.loadTimestampMilliseconds,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id:             map['id'],
      text:           map['text'],
      dateTimeInsert: DateTime.parse(map['dateTimeInsert']),
      authorId:       map['authorId'],
      likeCount:      map['likeCount'],
      isLiked:        map['isLiked'],
      loadTimestampMilliseconds:  DateTime.now().millisecondsSinceEpoch,
    );
  }
}
