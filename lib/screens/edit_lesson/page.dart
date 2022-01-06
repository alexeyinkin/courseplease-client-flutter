import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/screens/edit_lesson/bloc.dart';
import 'package:courseplease/screens/edit_lesson/screen.dart';
import 'package:flutter/widgets.dart';

class EditLessonPage extends BlocMaterialPage<AppConfiguration, EditLessonBloc> {
  EditLessonPage({
    required int lessonId,
  }) : super(
    key: ValueKey('EditLessonPage_$lessonId'),
    bloc: EditLessonBloc(lessonId: lessonId),
    createScreen: (b) => EditLessonScreen(bloc: b),
  );
}
