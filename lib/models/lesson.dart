import 'package:courseplease/models/reaction/commentable.dart';
import 'package:courseplease/models/reaction/likable.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:model_interfaces/model_interfaces.dart';
import 'lesson_interface.dart';

class Lesson implements WithId<int>, LessonInterface, Commentable, Likable {
  final int id;
  final int subjectId;
  final String title;
  final String type;
  final String externalId;
  final int durationSeconds;
  final String lang;
  final Map<String, String> coverUrls;
  final int authorId;
  final int commentCount;
  final int likeCount;
  final bool isLiked;
  final String body;
  final int loadTimestampMilliseconds;
  final DateTime dateTimeInsert;

  String? get coverUrl => coverUrls.isEmpty ? null : coverUrls.values.last;

  Lesson({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.type,
    required this.externalId,
    required this.durationSeconds,
    required this.lang,
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
      subjectId:        map['subjectId'],
      title:            map['title'],
      type:             map['type'],
      externalId:       map['externalId'],
      durationSeconds:  map['durationSeconds'],
      lang:             map['lang'],
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
