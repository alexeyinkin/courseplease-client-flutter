import 'package:clipboard/clipboard.dart';
import 'package:courseplease/screens/create_lesson/bloc.dart';
import 'package:courseplease/widgets/lesson/readonly_lesson_editor.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:courseplease/widgets/teacher_product_subject_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CreateLessonScreen extends StatelessWidget {
  final CreateLessonBloc bloc;

  CreateLessonScreen({
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CreateLessonScreenCubitState>(
      stream: bloc.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? bloc.initialState),
    );
  }

  Widget _buildWithState(CreateLessonScreenCubitState state) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: bloc.closeScreen),
        title: Text(tr('CreateLessonScreen.title')),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            TeacherProductSubjectDropdown(
              selectedId: state.subjectId,
              onChanged: bloc.setSubjectId,
            ),
            SmallPadding(),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: state.urlController,
                    labelText: tr('CreateLessonScreen.url'),
                  ),
                ),
                IconButton(
                  onPressed: () => _pasteUrl(state),
                  icon: Icon(Icons.paste),
                ),
              ],
            ),
            Opacity(
              opacity: .5,
              child: Text(
                tr('CreateLessonScreen.urlTip'),
                style: AppStyle.minor,
              ),
            ),
            SmallPadding(),
            _getPreviewIfCan(state),
            SmallPadding(),
            Center(
              child: ElevatedButtonWithProgress(
                child: Text(tr('common.buttons.save')),
                isLoading: state.actionInProgress == CreateLessonScreenAction.saving,
                onPressed: bloc.proceed,
                enabled: state.canProceed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pasteUrl(CreateLessonScreenCubitState state) async {
    final text = await FlutterClipboard.paste();
    state.urlController.text = text;
  }

  Widget _getPreviewIfCan(CreateLessonScreenCubitState state) {
    if (state.actionInProgress == CreateLessonScreenAction.parsing) {
      return SmallCircularProgressIndicator();
    }

    if (state.externalLesson == null) return Container();
    return ReadonlyLessonEditorWidget(lesson: state.externalLesson!);
  }
}
