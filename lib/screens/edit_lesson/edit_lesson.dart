import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/screens/edit_lesson/local_blocs/edit_lesson.dart';
import 'package:courseplease/screens/error_popup/error_popup.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/lesson/readonly_lesson_editor.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/teacher_product_subject_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class EditLessonScreen extends StatefulWidget {
  final Lesson lesson;

  EditLessonScreen({
    required this.lesson,
  });

  static void show({
    required BuildContext context,
    required Lesson lesson,
  }) {
    final appState = GetIt.instance.get<AppState>();
    final tabState = appState.getCurrentTabState();

    tabState.pushPage(
      MaterialPage(
        key: ValueKey('LessonScreen_${lesson.id}'),
        child: EditLessonScreen(
          lesson: lesson,
        ),
      ),
    );
  }

  @override
  _EditLessonScreenState createState() => _EditLessonScreenState(
    lesson: lesson,
  );
}

class _EditLessonScreenState extends State<EditLessonScreen> {
  final EditLessonScreenCubit _cubit;

  _EditLessonScreenState({
    required Lesson lesson,
  }) :
      _cubit = EditLessonScreenCubit(
        lesson: lesson,
      )
  {
    _cubit.errors.listen((_) => _onError());
    _cubit.successes.listen((_) => _onSuccess());
  }

  @override
  void dispose() {
    _cubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EditLessonScreenCubitState>(
      stream: _cubit.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _cubit.initialState),
    );
  }

  Widget _buildWithState(EditLessonScreenCubitState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('EditLessonScreen.title')),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            TeacherProductSubjectDropdown(
              selectedId: state.subjectId,
              onChanged: _cubit.setSubjectId,
            ),
            SmallPadding(),
            ReadonlyLessonEditorWidget(lesson: widget.lesson),
            SmallPadding(),
            Center(
              child: ElevatedButtonWithProgress(
                child: Text(tr('common.buttons.save')),
                isLoading: state.actionInProgress == EditLessonScreenAction.saving,
                onPressed: _cubit.proceed,
                enabled: state.canProceed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onError() {
    ErrorPopupScreen.show(context: context);
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }
}
