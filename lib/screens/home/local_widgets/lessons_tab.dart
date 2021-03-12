import 'package:courseplease/blocs/current_product_subject.dart';
import 'package:courseplease/widgets/auth/device_validity.dart';
import 'package:flutter/material.dart';
import '../../../widgets/lesson_grid.dart';
import '../../../models/filters/lesson.dart';
import 'package:provider/provider.dart';

class LessonsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CurrentProductSubjectBloc>();

    return StreamBuilder<int>(
      stream: bloc.outCurrentId,
      builder: (context, snapshot) {
        final filter = LessonFilter(subjectId: snapshot.data);
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
