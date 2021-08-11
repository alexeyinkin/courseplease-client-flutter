import 'dart:convert';

import 'package:courseplease/models/external_lesson.dart';
import 'package:courseplease/services/net/api_client.dart';

extension CreateLike on ApiClient {
  Future<ExternalLesson?> parseExternalLesson(ParseExternalLessonRequest request) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.get,
      path: '/api1/{@lang}/lms/parse-external-lesson',
      queryParameters: {
        'request': jsonEncode(request),
      },
    );
    if (mapResponse.data.isEmpty) return null;
    return ExternalLesson.fromMap(mapResponse.data);
  }
}

class ParseExternalLessonRequest extends RequestBody {
  final String url;

  ParseExternalLessonRequest({
    required this.url,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}
