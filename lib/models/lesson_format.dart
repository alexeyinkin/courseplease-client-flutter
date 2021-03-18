class LessonFormat {
  final String intName;
  final String title;

  LessonFormat({
    required this.intName,
    required this.title,
  });

  factory LessonFormat.fromMap(Map<String, dynamic> map) {
    return LessonFormat(
      intName:  map['intName'],
      title:    map['title'],
    );
  }
}
