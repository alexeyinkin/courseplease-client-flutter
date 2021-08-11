import 'package:courseplease/services/net/api_client.dart';

class LessonInfo extends RequestBody {
  final int subjectId;

  LessonInfo({
    required this.subjectId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
    };
  }
}
