import 'package:courseplease/blocs/current_product_subject.dart';
import 'package:flutter/material.dart';
import '../../../widgets/lesson_grid.dart';
import '../../../models/filters/lesson.dart';
import 'package:provider/provider.dart';

class LessonsTab extends StatelessWidget {
// class LessonsTab extends StatefulWidget {
//   int subjectId;
//
//   LessonsTab({Key key, @required this.subjectId}) : super(key: key);
//
//   @override
//   State<LessonsTab> createState() {
//     return LessonsTabState();
//   }
// }
//
// class LessonsTabState extends State<LessonsTab> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CurrentProductSubjectBloc>();

    return Center(
      //key: PageStorageKey('e'),
      //child: ImageGrid(key: PageStorageKey('i'), categoryId: widget.categoryId),
      child: StreamBuilder<int>(
        stream: bloc.outCurrentId,
        builder: (context, snapshot) {
          return LessonGrid(
            filter: LessonFilter(subjectId: snapshot.data),
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
          );
        }
      ),
    );
  }
}
