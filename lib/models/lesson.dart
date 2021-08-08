import 'package:courseplease/models/reaction/commentable.dart';
import 'package:courseplease/models/reaction/likable.dart';
import 'package:courseplease/utils/utils.dart';
import 'interfaces.dart';

class Lesson implements WithId<int>, Commentable, Likable {
  final int id;
  final String title;
  final String type;
  final String externalId;
  final int durationSeconds;
  final Map<String, String> coverUrls;
  final int authorId;
  final int commentCount;
  final int likeCount;
  final bool isLiked;
  final String body;
  final int loadTimestampMilliseconds;
  final DateTime dateTimeInsert;

  Lesson({
    required this.id,
    required this.title,
    required this.type,
    required this.externalId,
    required this.durationSeconds,
    required this.coverUrls,
    required this.authorId,
    required this.commentCount,
    required this.likeCount,
    required this.isLiked,
    required this.body,
    required this.loadTimestampMilliseconds,
    required this.dateTimeInsert,
  });

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id:               map['id'],
      title:            map['title'],
      type:             map['type'],
      externalId:       map['externalId'],
      durationSeconds:  map['durationSeconds'],
      coverUrls:        toStringStringMap(map['coverUrls']),
      authorId:         map['authorId'],
      commentCount:     map['commentCount'],
      likeCount:        map['likeCount'],
      isLiked:          map['isLiked'],
      body:             map['body'] ?? '',
      loadTimestampMilliseconds:  DateTime.now().millisecondsSinceEpoch,
      dateTimeInsert:   DateTime.parse(map['dateTimeInsert']),
    );
  }
}
