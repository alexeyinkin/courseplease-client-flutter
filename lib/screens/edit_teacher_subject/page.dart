import 'package:app_state/app_state.dart';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:flutter/foundation.dart';

import 'bloc.dart';
import 'screen.dart';

class EditTeacherSubjectPage extends BlocMaterialPage<MyPageConfiguration, EditTeacherSubjectBloc> {
  EditTeacherSubjectPage({
    required TeacherSubject teacherSubjectClone,
  }) : super(
    key: ValueKey('EditTeacherSubjectPage'),
    bloc: EditTeacherSubjectBloc(teacherSubjectClone: teacherSubjectClone),
    createScreen: (b) => EditTeacherSubjectScreen(bloc: b),
  );
}
