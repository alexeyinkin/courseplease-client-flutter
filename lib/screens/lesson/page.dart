import 'package:app_state/app_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/foundation.dart';

import 'bloc.dart';
import 'screen.dart';

class LessonPage extends BlocMaterialPage<ScreenConfiguration, LessonBloc> {
  LessonPage({
    required int id,
    bool autoplay = false,
  }) : super(
    key: ValueKey('Lesson_$id'),
    bloc: LessonBloc(lessonId: id),
    createScreen: (b) => LessonScreen(
      bloc: b,
      autoplay: autoplay,
    ),
  );
}
