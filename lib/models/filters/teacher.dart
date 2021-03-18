import 'dart:convert';
import 'abstract.dart';

class TeacherFilter extends AbstractFilter {
  final int? subjectId;

  TeacherFilter({
    required this.subjectId,
  });

  String toString() {
    return jsonEncode({'subjectId': subjectId});
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
    };
  }
}
