import 'package:courseplease/screens/edit_teacher_subject/local_widgets/edit_body_tab.dart';
import 'package:courseplease/screens/edit_teacher_subject/local_widgets/edit_prices_tab.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';

class EditTeacherSubjectScreen extends StatelessWidget {
  final EditTeacherSubjectBloc bloc;

  EditTeacherSubjectScreen({
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EditTeacherSubjectState>(
      stream: bloc.states,
      builder: (context, snapshot) => _buildWithState(
        snapshot.data ?? bloc.initialState,
      ),
    );
  }

  Widget _buildWithState(EditTeacherSubjectState state) {
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
          onChanged: bloc.setEnabled,
        ),
      ],
    );
  }

  Widget _getSaveButton(EditTeacherSubjectState state) {
    return ElevatedButtonWithProgress(
      child: Text(tr('common.buttons.save')),
      isLoading: state.actionInProgress == EditTeacherSubjectAction.save,
      onPressed: bloc.save,
    );
  }
}
