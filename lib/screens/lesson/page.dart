import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:flutter/foundation.dart';

import 'bloc.dart';
import 'screen.dart';

class LessonPage extends BlocMaterialPage<MyPageConfiguration, LessonBloc> {
  static const factoryKey = 'LessonPage';

  LessonPage({
    required int lessonId,
    bool autoplay = false,
  }) : super(
    key: ValueKey(formatKey(lessonId: lessonId)),
    bloc: LessonBloc(lessonId: lessonId),
    createScreen: (b) => LessonScreen(
      bloc: b,
      autoplay: autoplay,
    ),
  );

  static String formatKey({required int lessonId}) {
    return '${factoryKey}_$lessonId';
  }
}
