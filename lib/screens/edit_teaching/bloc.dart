import 'package:app_state/app_state.dart';
import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/page.dart';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/edit_teacher_subject/events.dart';
import 'package:courseplease/screens/edit_teacher_subject/page.dart';
import 'package:courseplease/screens/edit_teaching/configurations.dart';
import 'package:courseplease/screens/select_product_subject/events.dart';
import 'package:get_it/get_it.dart';

class EditTeachingBloc extends AppPageBloc {
  final _authenticationBloc = GetIt.instance.get<AuthenticationBloc>();

  @override
  MyPageConfiguration? getConfiguration() => const EditTeachingConfiguration();

  @override
  void onForegroundClosed(PageBlocCloseEvent event) {
    if (event is ProductSubjectSelectedEvent) {
      _onSubjectSelected(event.productSubjectId);
      return;
    }

    if (event is TeacherSubjectEditedEvent) {
      _onTeacherSubjectEdited(event.productSubjectId);
      return;
    }
  }

  void _onSubjectSelected(int subjectId) {
    final state = _authenticationBloc.currentState;

    for (final ts in state.data!.teacherSubjects) {
      if (ts.subjectId == subjectId) {
        _showEditSubjectScreen(TeacherSubject.from(ts));
        return;
      }
    }

    _addSubject(subjectId);
  }

  void _showEditSubjectScreen(TeacherSubject teacherSubjectClone) {
    GetIt.instance.get<AppState>().pushPage(
      EditTeacherSubjectPage(
        teacherSubjectClone: teacherSubjectClone,
      ),
    );
  }

  void _addSubject(int subjectId) {
    _showEditSubjectScreen(TeacherSubject.createBySubjectId(subjectId));
  }

  void _onTeacherSubjectEdited(int subjectId) {
    // TODO: Scroll to. See screen.dart for old commented out code.
    //       Or sort the list so that changed go first, scroll to top.
  }
}
