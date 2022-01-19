import 'package:app_state/app_state.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/my_lesson_list/bloc.dart';
import 'package:courseplease/screens/my_lesson_list/screen.dart';
import 'package:flutter/widgets.dart';

class MyLessonListPage extends BlocMaterialPage<MyPageConfiguration, MyLessonListBloc> {
  static const factoryKey = 'MyLessonListPage';

  MyLessonListPage({
    required int subjectId,
  }) : super(
    key: ValueKey(formatKey(subjectId: subjectId)),
    factoryKey: factoryKey,
    bloc: MyLessonListBloc(filter: MyLessonFilter(subjectIds: [subjectId])),
    createScreen: (b) => MyLessonListScreen(bloc: b),
  );

  static String formatKey({
    required int subjectId,
  }) {
    return '${factoryKey}_$subjectId';
  }
}
