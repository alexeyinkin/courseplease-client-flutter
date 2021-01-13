import 'package:courseplease/blocs/current_product_subject.dart';
import 'package:flutter/material.dart';
import '../../../models/filters/teacher.dart';
import '../../../widgets/teacher_grid.dart';
import 'package:provider/provider.dart';

class TeachersTab extends StatelessWidget {
//class TeachersTab extends StatefulWidget {
//   //int subjectId;
//
//   TeachersTab({
//     Key key,
//     //@required this.subjectId,
//   }) : super(key: key);
//
//   @override
//   State<TeachersTab> createState() {
//     return TeachersTabState();
//   }
// }
//
// class TeachersTabState extends State<TeachersTab> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CurrentProductSubjectBloc>();

    return Center(
      //key: PageStorageKey('e'),
      //child: ImageGrid(key: PageStorageKey('i'), categoryId: widget.categoryId),
      child: StreamBuilder<int>(
        stream: bloc.outCurrentId,
        builder: (context, snapshot) {
          return TeacherGrid(filter: TeacherFilter(subjectId: snapshot.data));
        }
      ),
    );
  }
}
