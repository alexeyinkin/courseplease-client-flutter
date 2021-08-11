import 'lesson_interface.dart';

class ExternalLesson implements LessonInterface {
  final id = 0;
  final type = 'video';

  final String serviceName;
  final String externalId;
  final String title;
  final int durationSeconds;
  final String body;
  final String? coverUrl;
  final String lang;

  ExternalLesson({
    required this.serviceName,
    required this.externalId,
    required this.title,
    required this.durationSeconds,
    required this.body,
    required this.coverUrl,
    required this.lang,
  });

  factory ExternalLesson.fromMap(Map<String, dynamic> map) {
    return ExternalLesson(
      serviceName:      map['serviceName'],
      externalId:       map['externalId'],
      title:            map['title'],
      durationSeconds:  map['durationSeconds'],
      body:             map['body'],
      coverUrl:         map['coverUrl'],
      lang:             map['lang'],
    );
  }
}
