import 'package:courseplease/models/external_lesson.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/language.dart';
import 'package:courseplease/widgets/lesson/lesson_cover.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ExternalLessonWidget extends StatelessWidget {
  final ExternalLesson externalLesson;

  ExternalLessonWidget({
    required this.externalLesson,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: LessonCoverWidget(
            lesson: externalLesson,
            showPlayButton: false,
          ),
        ),
        Text(
          externalLesson.title,
          style: AppStyle.h2,
        ),
        LanguageWidget(lang: externalLesson.lang),
        SmallPadding(),
        Container(
          child: Markdown(
            data: externalLesson.body,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }
}
