import 'package:courseplease/models/lesson_interface.dart';
import 'package:courseplease/widgets/lesson/text_lesson_cover.dart';
import 'package:courseplease/widgets/lesson/video_lesson_cover_with_time.dart';
import 'package:flutter/widgets.dart';

class LessonCoverWidget extends StatelessWidget {
  final LessonInterface lesson;
  final bool showPlayButton;

  LessonCoverWidget({
    required this.lesson,
    required this.showPlayButton,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _getContent(),
    );
  }

  Widget _getContent() {
    switch (lesson.type) {
      case 'text':
        return TextLessonCoverWidget(lesson: lesson);
      case 'video':
        return VideoLessonCoverWithTimeWidget(
          lesson: lesson,
          showPlayButton: showPlayButton,
        );
    }

    throw Exception('Unknown lesson type: ' + lesson.type);
  }
}
