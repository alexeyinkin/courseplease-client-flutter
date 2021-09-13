import 'abstract.dart';

class GalleryLessonFilter extends AbstractFilter {
  final int? subjectId;
  final int? teacherId;

  GalleryLessonFilter({
    this.subjectId,
    this.teacherId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'teacherId': teacherId,
    };
  }
}
