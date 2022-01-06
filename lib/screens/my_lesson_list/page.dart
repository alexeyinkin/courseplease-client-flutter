import 'package:app_state/app_state.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/screens/my_lesson_list/bloc.dart';
import 'package:courseplease/screens/my_lesson_list/screen.dart';
import 'package:flutter/widgets.dart';

class MyLessonListPage extends BlocMaterialPage<AppConfiguration, MyLessonListBloc> {
  MyLessonListPage({
    required MyLessonFilter filter,
  }) : super(
    key: ValueKey('MyLessonListPage_$filter'),
    bloc: MyLessonListBloc(filter: filter),
    createScreen: (b) => MyLessonListScreen(bloc: b),
  );
}
