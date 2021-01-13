import 'dart:convert';
import 'package:meta/meta.dart';
import 'abstract.dart';

class TeacherFilter extends AbstractFilter {
  final int subjectId;
  TeacherFilter({
    @required this.subjectId,
  });

  String toString() {
    return jsonEncode({'subjectId': subjectId});
  }

  @override
  Map<String, String> toQueryParams() {
    return {'subjectId': subjectId.toString()};
  }
}
