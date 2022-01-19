import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/teacher/bloc.dart';
import 'package:courseplease/screens/teacher/screen.dart';
import 'package:flutter/widgets.dart';

class TeacherPage extends BlocMaterialPage<MyPageConfiguration, TeacherBloc> {
  static const factoryKey = 'TeacherPage';

  TeacherPage({
    required int teacherId,
    int? initialSubjectId,
  }) : super(
    key: ValueKey(formatKey(teacherId: teacherId)),
    bloc: TeacherBloc(teacherId: teacherId, selectedSubjectId: initialSubjectId),
    createScreen: (c) => TeacherScreen(bloc: c),
  );

  static String formatKey({required int teacherId}) {
    return '${factoryKey}_$teacherId';
  }
}
