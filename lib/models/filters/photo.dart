import 'dart:convert';
import 'package:meta/meta.dart';
import 'abstract.dart';

class GalleryPhotoFilter extends AbstractFilter {
  final int subjectId;
  final int teacherId; // Nullable

  GalleryPhotoFilter({
    @required this.subjectId,
    this.teacherId,
  });

  @override
  String toString() {
    return jsonEncode({'subjectId': subjectId, 'teacherId': teacherId});
  }

  @override
  Map<String, String> toQueryParams() {
    var result = Map<String, String>();

    result['subjectId'] = subjectId.toString();

    if (teacherId != null) {
      result['teacherId'] = teacherId.toString();
    }

    return result;
  }
}

class UnsortedPhotoFilter extends AbstractFilter {
  @override
  String toString() {
    return '';
  }

  @override
  Map<String, String> toQueryParams() {
    var result = Map<String, String>();
    return result;
  }
}
