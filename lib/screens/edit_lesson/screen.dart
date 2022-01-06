import 'package:courseplease/screens/edit_lesson/bloc.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/lesson/readonly_lesson_editor.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:courseplease/widgets/teacher_product_subject_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EditLessonScreen extends StatelessWidget {
  final EditLessonBloc bloc;

  EditLessonScreen({
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EditLessonCubitState>(
      stream: bloc.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? bloc.initialState),
    );
  }

  Widget _buildWithState(EditLessonCubitState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('EditLessonScreen.title')),
      ),
      body: _getBody(state),
    );
  }

  Widget _getBody(EditLessonCubitState state) {
    final lesson = state.lesson;
    if (lesson == null) return SmallCircularProgressIndicator();

    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          TeacherProductSubjectDropdown(
            selectedId: state.subjectId,
            onChanged: bloc.setSubjectId,
          ),
          SmallPadding(),
          ReadonlyLessonEditorWidget(lesson: lesson),
          SmallPadding(),
          Center(
            child: ElevatedButtonWithProgress(
              child: Text(tr('common.buttons.save')),
              isLoading: state.actionInProgress == EditLessonScreenAction.saving,
              onPressed: bloc.proceed,
              enabled: state.canProceed,
            ),
          ),
        ],
      ),
    );
  }
}
