import 'package:clipboard/clipboard.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/screens/create_lesson/local_blocs/create_lesson.dart';
import 'package:courseplease/screens/create_lesson/local_widgets/external_lesson.dart';
import 'package:courseplease/screens/error_popup/error_popup.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:courseplease/widgets/teacher_product_subject_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CreateLessonScreen extends StatefulWidget {
  final MyLessonFilter filter;

  CreateLessonScreen({
    required this.filter,
  });

  static void show({
    required BuildContext context,
    required MyLessonFilter filter,
  }) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateLessonScreen(
          filter: filter,
        ),
      ),
    );
  }

  @override
  _CreateLessonScreenState createState() => _CreateLessonScreenState(
    filter: filter,
  );
}

class _CreateLessonScreenState extends State<CreateLessonScreen> {
  final CreateLessonScreenCubit _cubit;

  _CreateLessonScreenState({
    required MyLessonFilter filter,
  }) :
      _cubit = CreateLessonScreenCubit(
        initialSubjectId: filter.subjectIds.isEmpty ? null : filter.subjectIds.first,
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
    return StreamBuilder<CreateLessonScreenCubitState>(
      stream: _cubit.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _cubit.initialState),
    );
  }

  Widget _buildWithState(CreateLessonScreenCubitState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('CreateLessonScreen.title')),
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
                onPressed: _cubit.proceed,
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
    return ExternalLessonWidget(externalLesson: state.externalLesson!);
  }

  void _onError() {
    ErrorPopupScreen.show(context);
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }
}