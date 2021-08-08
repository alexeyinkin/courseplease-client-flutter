import 'dart:convert';
import 'abstract.dart';

class GalleryLessonFilter extends AbstractFilter {
  final int? subjectId;
  final int? teacherId;

  GalleryLessonFilter({
    this.subjectId,
    this.teacherId,
  });

  @override
  String toString() {
    return jsonEncode({'subjectId': subjectId, 'teacherId': teacherId});
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'teacherId': teacherId,
    };
  }
}
