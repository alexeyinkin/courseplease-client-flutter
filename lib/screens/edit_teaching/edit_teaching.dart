import 'dart:async';
import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/screens/edit_teacher_subject/edit_teacher_subject.dart';
import 'package:courseplease/screens/edit_teaching/local_widgets/view_teacher_subject.dart';
import 'package:courseplease/screens/select_product_subject/select_product_subject.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class EditTeachingScreen extends StatefulWidget {
  static const routeName = '/editTeaching';

  @override
  State<EditTeachingScreen> createState() => _EditTeachingScreenState();
}

class _EditTeachingScreenState extends State<EditTeachingScreen> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authenticationCubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data),
    );
  }

  Widget _buildWithState(AuthenticationState state) {
    if (state == null) return Container();

    final children = <Widget>[];

    for (final teacherSubject in state.data.teacherSubjects) {
      children.add(
        ViewTeacherSubjectWidget(
          teacherSubject: teacherSubject,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(tr('EditTeachingScreen.title')),
            Spacer(),
            ElevatedButton(
              child: Icon(Icons.add),
              onPressed: () => _onAddSubjectPressed(state),
            ),
          ],
        ),
      ),
      body: ListView(
        controller: _scrollController,
        children: alternateWidgetListWith(children, SmallPadding()),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }

  void _onAddSubjectPressed(AuthenticationState state) async {
    final id = await SelectProductSubjectScreen.selectSubjectId(context);
    if (id == null) return;

    for (final ts in state.data.teacherSubjects) {
      if (ts.subjectId == id) {
        _editSubject(ts);
        return;
      }
    }

    _addSubject(id);
  }

  void _editSubject(TeacherSubject ts) {
    _showEditSubjectScreen(TeacherSubject.from(ts));
  }

  void _addSubject(int subjectId) async {
    await _showEditSubjectScreen(TeacherSubject.createBySubjectId(subjectId));
    _scrollToBottom();
  }

  Future<void> _showEditSubjectScreen(TeacherSubject teacherSubjectClone) async {
    await Navigator.of(context).pushNamed(
      EditTeacherSubjectScreen.routeName,
      arguments: EditTeacherSubjectScreenArguments(
        teacherSubjectClone: teacherSubjectClone,
      ),
    );
  }

  void _scrollToBottom() {
    // For some reason instant jumping like this:
    //_scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    //
    // ... as described in https://stackoverflow.com/a/58112953/11382675
    // does not work. If scrolled from high enough, it bounces back to the top.
    // Scrolling that way only works if the starting location
    // is close to the end of the list.
    //
    // So use animation for now:
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
