import 'dart:convert';
import 'abstract.dart';

class ViewImageFilter extends AbstractFilter {
  final int? subjectId;
  final int? teacherId;

  ViewImageFilter({
    required this.subjectId,
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

class EditImageFilter extends AbstractFilter {
  final List<int> albumIds;
  final List<int> contactIds;
  final List<int> purposeIds;
  final List<int> subjectIds;
  final bool unsorted;

  EditImageFilter({
    this.albumIds = const <int>[],
    this.contactIds = const <int>[],
    this.purposeIds = const <int>[],
    this.subjectIds = const <int>[],
    this.unsorted = false,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'albumIds': albumIds,
      'contactIds': contactIds,
      'purposeIds': purposeIds,
      'subjectIds': subjectIds,
      'unsorted': unsorted,
    };
  }
}
