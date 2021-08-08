import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/widgets/duration.dart';
import 'package:courseplease/widgets/lesson/text_lesson_cover.dart';
import 'package:flutter/material.dart';

class VideoLessonCoverWithTimeWidget extends StatelessWidget {
  final Lesson lesson;
  final bool showPlayButton;

  VideoLessonCoverWithTimeWidget({
    required this.lesson,
    required this.showPlayButton,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Stack(
        children: [
          Positioned(top: 0, bottom: 0, left: 0, right: 0, child: TextLessonCoverWidget(lesson: lesson)),
          _getPlayButtonIfNeed(),
          Positioned(
            right: 3,
            bottom: 3,
            child: DurationWidget(duration: Duration(seconds: lesson.durationSeconds)),
          ),
        ],
      ),
    );
  }

  Widget _getPlayButtonIfNeed() {
    if (!showPlayButton) return Container();

    return Center(
      child: Opacity(
        opacity: .7,
        child: Icon(
          Icons.play_circle_fill,
          size: 64,
        ),
      ),
    );
  }
}
