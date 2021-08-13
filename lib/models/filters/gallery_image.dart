import 'abstract.dart';

class GalleryImageFilter extends AbstractFilter {
  final int? subjectId;
  final int? teacherId;
  final int purposeId;

  GalleryImageFilter({
    required this.subjectId,
    this.teacherId,
    required this.purposeId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'teacherId': teacherId,
      'purposeId': purposeId,
    };
  }
}
