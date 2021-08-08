import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/widgets/error/id.dart';
import 'package:flutter/widgets.dart';

class TextLessonCoverWidget extends StatelessWidget {
  final Lesson lesson;

  TextLessonCoverWidget({
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    final url = _getUrl();
    if (url == null) return IdErrorWidget(object: lesson);

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
    );
  }

  String? _getUrl() {
    final urlPath = lesson.coverUrls['1920x1080'];
    if (urlPath == null) return null;
    return 'https://courseplease.com' + urlPath;
  }
}
