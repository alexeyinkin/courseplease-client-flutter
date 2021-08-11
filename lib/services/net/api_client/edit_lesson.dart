import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/lesson_info.dart';

extension EditLesson on ApiClient {
  Future<void> createLesson(EditLessonRequest request) {
    return sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/lms/edit-lesson',
      body: request,
    );
  }
}

class EditLessonRequest extends RequestBody {
  final int id;
  final LessonInfo info;

  EditLessonRequest({
    required this.id,
    required this.info,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'info': info.toJson(),
    };
  }
}
