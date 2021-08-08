import 'package:courseplease/models/filters/abstract.dart';

class MyLessonFilter extends AbstractFilter {
  final List<int> subjectIds;

  MyLessonFilter({
    this.subjectIds = const [],
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'subjectIds': subjectIds,
    };
  }
}
