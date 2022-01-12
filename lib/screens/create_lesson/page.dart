import 'package:app_state/app_state.dart';
import 'package:collection/collection.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:courseplease/screens/create_lesson/bloc.dart';
import 'package:courseplease/screens/create_lesson/screen.dart';
import 'package:flutter/material.dart';

class CreateLessonPage extends BlocMaterialPage<ScreenConfiguration, CreateLessonBloc> {
  CreateLessonPage({
    required MyLessonFilter filter,
  }) : super(
    key: ValueKey('CreateLessonPage_$filter'),
    bloc: CreateLessonBloc(initialSubjectId: filter.subjectIds.firstOrNull),
    createScreen: (b) => CreateLessonScreen(bloc: b),
  );
}
