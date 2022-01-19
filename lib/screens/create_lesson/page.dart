import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/create_lesson/bloc.dart';
import 'package:courseplease/screens/create_lesson/screen.dart';
import 'package:flutter/material.dart';

class CreateLessonPage extends BlocMaterialPage<MyPageConfiguration, CreateLessonBloc> {
  static const factoryKey = 'CreateLessonPage';

  CreateLessonPage({
    required int? subjectId,
  }) : super(
    key: ValueKey(formatKey(subjectId: subjectId)),
    bloc: CreateLessonBloc(initialSubjectId: subjectId),
    createScreen: (b) => CreateLessonScreen(bloc: b),
  );

  static String formatKey({
    required int? subjectId,
  }) {
    return '${factoryKey}_$subjectId';
  }
}
