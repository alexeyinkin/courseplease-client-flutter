import 'package:app_state/app_state.dart';

class TeacherSubjectEditedEvent extends PageBlocCloseEvent {
  final int productSubjectId;

  TeacherSubjectEditedEvent({
    required this.productSubjectId,
  });
}
