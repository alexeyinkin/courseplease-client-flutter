import 'package:app_state/app_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:courseplease/screens/teacher/bloc.dart';
import 'package:courseplease/screens/teacher/screen.dart';
import 'package:flutter/widgets.dart';

class TeacherPage extends BlocMaterialPage<ScreenConfiguration, TeacherBloc> {
  TeacherPage({
    required int teacherId,
    int? initialSubjectId,
  }) : super(
    key: ValueKey('TeacherPage_${teacherId}_$initialSubjectId'),
    bloc: TeacherBloc(teacherId: teacherId, selectedSubjectId: initialSubjectId),
    createScreen: (c) => TeacherScreen(cubit: c),
  );
}
