import 'package:courseplease/utils/utils.dart';
import 'package:meta/meta.dart';
import 'interfaces.dart';
import 'teacher.dart';

class Lesson implements WithId<int> {
  final int id;
  final String title;
  final String type;
  final String externalId;
  final int durationSeconds;
  final Map<String, String> coverUrls;
  final Teacher author;
  final String body;

  Lesson({
    @required this.id,
    @required this.title,
    @required this.type,
    @required this.externalId,
    @required this.durationSeconds,
    @required this.coverUrls,
    @required this.author,
    @required this.body,
  });

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'],
      title: map['title'],
      type: map['type'],
      externalId: map['externalId'],
      durationSeconds: map['durationSeconds'],
      coverUrls: toStringStringMap(map['coverUrls']),
      author: Teacher.fromMap(map['author']),
      body: map['body'] ?? '',
    );
  }
}
