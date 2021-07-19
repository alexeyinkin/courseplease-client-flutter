import 'package:courseplease/models/reaction/commentable.dart';
import 'package:courseplease/models/reaction/likable.dart';
import 'package:courseplease/utils/utils.dart';
import 'interfaces.dart';
import 'teacher.dart';

class Lesson implements WithId<int>, Commentable, Likable {
  final int id;
  final String title;
  final String type;
  final String externalId;
  final int durationSeconds;
  final Map<String, String> coverUrls;
  final Teacher author;
  final int commentCount;
  final int likeCount;
  final bool isLiked;
  final String body;
  final int loadTimestampMilliseconds;

  Lesson({
    required this.id,
    required this.title,
    required this.type,
    required this.externalId,
    required this.durationSeconds,
    required this.coverUrls,
    required this.author,
    required this.commentCount,
    required this.likeCount,
    required this.isLiked,
    required this.body,
    required this.loadTimestampMilliseconds,
  });

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id:               map['id'],
      title:            map['title'],
      type:             map['type'],
      externalId:       map['externalId'],
      durationSeconds:  map['durationSeconds'],
      coverUrls:        toStringStringMap(map['coverUrls']),
      author:           Teacher.fromMap(map['author']),
      commentCount:     map['commentCount'],
      likeCount:        map['likeCount'],
      isLiked:          map['isLiked'],
      body:             map['body'] ?? '',
      loadTimestampMilliseconds:  DateTime.now().millisecondsSinceEpoch,
    );
  }
}
