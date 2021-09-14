import 'abstract.dart';

class GalleryLessonFilter extends AbstractFilter {
  final int? subjectId;
  final int? teacherId;
  final List<String> langs;
  final String? search;

  GalleryLessonFilter({
    this.subjectId,
    this.teacherId,
    this.langs = const [],
    this.search,
  });

  GalleryLessonFilter withSearch(String? search) {
    return GalleryLessonFilter(
      subjectId:  subjectId,
      teacherId:  teacherId,
      langs:      langs,
      search:     search == '' ? null : search,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'subjectId':  subjectId,
      'teacherId':  teacherId,
      'langs':      langs,
      'search':     search,
    };
  }
}
