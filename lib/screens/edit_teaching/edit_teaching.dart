import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/screens/edit_teaching/local_widgets/view_teacher_subject.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class EditTeachingScreen extends StatefulWidget {
  static const routeName = '/editTeaching';

  @override
  State<EditTeachingScreen> createState() => _EditTeachingScreenState();
}

class _EditTeachingScreenState extends State<EditTeachingScreen> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Teaching Subjects"),
      ),
      body: StreamBuilder(
        stream: _authenticationCubit.outState,
        builder: (context, snapshot) => _buildWithState(snapshot.data),
      ),
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

    return ListView(
      children: children,
    );
  }
}
