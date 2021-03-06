import 'dart:async';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/screens/edit_teacher_subject/local_blocs/edit_teacher_subject.dart';
import 'package:courseplease/screens/edit_teacher_subject/local_widgets/edit_body_tab.dart';
import 'package:courseplease/screens/edit_teacher_subject/local_widgets/edit_prices_tab.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditTeacherSubjectScreen extends StatefulWidget {
  final TeacherSubject teacherSubjectClone;

  EditTeacherSubjectScreen({
    required this.teacherSubjectClone,
  });

  @override
  _EditTeacherSubjectScreenState createState() => _EditTeacherSubjectScreenState(
    teacherSubjectClone: teacherSubjectClone,
  );

  static Future<void> show({
    required BuildContext context,
    required TeacherSubject teacherSubjectClone,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTeacherSubjectScreen(
          teacherSubjectClone: teacherSubjectClone,
        ),
      ),
    );
  }
}

class _EditTeacherSubjectScreenState extends State<EditTeacherSubjectScreen> {
  late final EditTeacherSubjectCubit _editTeacherSubjectCubit;

  _EditTeacherSubjectScreenState({
    required TeacherSubject teacherSubjectClone,
  }) {
    _editTeacherSubjectCubit = EditTeacherSubjectCubit(
      teacherSubjectClone: teacherSubjectClone,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EditTeacherSubjectState>(
      stream: _editTeacherSubjectCubit.outState,
      builder: (context, snapshot) => _buildWithState(
        snapshot.data ?? _editTeacherSubjectCubit.initialState,
      ),
    );
  }

  Widget _buildWithState(EditTeacherSubjectState state) {
    if (state.closeScreen) {
      Timer(Duration.zero, () {
        Navigator.of(context).pop();
      });

      return Container(); // TODO: Show confirmation.
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            _getSubjectTitleWidget(state),
            Spacer(),
            _getSaveButton(state),
          ],
        ),
      ),
      body: DefaultTabController( // TODO: Side-by-side on horizontal tablet?
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: tr('EditTeacherSubjectScreen.tabs.prices.title')),
                Tab(text: tr('EditTeacherSubjectScreen.tabs.body.title')),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  EditPricesTabWidget(teacherSubjectClone: state.teacherSubjectClone),
                  EditBodyTabWidget(textEditingController: state.bodyTextEditingController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSubjectTitleWidget(EditTeacherSubjectState state) {
    final subjectTitle = (state.productSubject == null)
        ? '...'
        : state.productSubject!.title;

    return Row(
      children: [
        Text(tr('EditTeacherSubjectScreen.title', namedArgs: {'subjectTitle': subjectTitle})),
        SmallPadding(),
        Switch(
          value: state.teacherSubjectClone.enabled,
          onChanged: _editTeacherSubjectCubit.setEnabled,
        ),
      ],
    );
  }

  Widget _getSaveButton(EditTeacherSubjectState state) {
    return ElevatedButtonWithProgress(
      child: Text(tr('common.buttons.save')),
      isLoading: state.actionInProgress == EditTeacherSubjectAction.save,
      onPressed: _save,
    );
  }

  void _save() {
    _editTeacherSubjectCubit.save();
  }
}
