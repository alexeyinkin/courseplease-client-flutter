import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/lesson_info.dart';

extension CreateLesson on ApiClient {
  Future<void> createLesson(CreateLessonRequest request) {
    return sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/lms/create-lesson',
      body: request,
    );
  }
}

class CreateLessonRequest extends RequestBody {
  final String url;
  final LessonInfo info;

  CreateLessonRequest({
    required this.url,
    required this.info,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'info': info.toJson(),
    };
  }
}
