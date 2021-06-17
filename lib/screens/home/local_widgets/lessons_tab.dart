import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/widgets/auth/device_validity.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import '../../../widgets/lesson_grid.dart';
import '../../../models/filters/lesson.dart';
import 'package:provider/provider.dart';

class LessonsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TreePositionBloc<int, ProductSubject>>();

    return StreamBuilder<int>(
      stream: bloc.outCurrentId,
      builder: (context, snapshot) {
        final subjectId = snapshot.data;
        if (subjectId == null) {
          return SmallCircularProgressIndicator(); // TODO: Allow null in LessonFilter to show all lessons?
        }
        final filter = LessonFilter(subjectId: subjectId);
        return _buildWithFilter(filter);
      }
    );
  }

  Widget _buildWithFilter(LessonFilter filter) {
    return CommonDeviceValidityWidget(
      validDeviceBuilder: (_) => _buildValidWithFilter(filter),
    );
  }

  Widget _buildValidWithFilter(LessonFilter filter) {
    return LessonGrid(
      filter: filter,
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
    );
  }
}
