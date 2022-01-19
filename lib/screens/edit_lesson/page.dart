import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/edit_lesson/bloc.dart';
import 'package:courseplease/screens/edit_lesson/screen.dart';
import 'package:flutter/widgets.dart';

class EditLessonPage extends BlocMaterialPage<MyPageConfiguration, EditLessonBloc> {
  static const factoryKey = 'EditLessonPage';

  EditLessonPage({
    required int lessonId,
  }) : super(
    key: ValueKey(formatKey(lessonId: lessonId)),
    bloc: EditLessonBloc(lessonId: lessonId),
    createScreen: (b) => EditLessonScreen(bloc: b),
  );

  static String formatKey({
    required int lessonId,
  }) {
    return '${factoryKey}_$lessonId';
  }
}
