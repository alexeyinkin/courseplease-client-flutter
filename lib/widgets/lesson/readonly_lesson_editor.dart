import 'package:courseplease/models/lesson_interface.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/language.dart';
import 'package:courseplease/widgets/lesson/lesson_cover.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReadonlyLessonEditorWidget extends StatelessWidget {
  final LessonInterface lesson;

  ReadonlyLessonEditorWidget({
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: LessonCoverWidget(
            lesson: lesson,
            showPlayButton: false,
          ),
        ),
        Text(
          lesson.title,
          style: AppStyle.h2,
        ),
        _getLanguageIfAny(),
        SmallPadding(),
        Container(
          child: Markdown(
            data: lesson.body,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }

  Widget _getLanguageIfAny() {
    if (lesson.lang == '') return Container();
    return LanguageWidget(lang: lesson.lang);
  }
}
