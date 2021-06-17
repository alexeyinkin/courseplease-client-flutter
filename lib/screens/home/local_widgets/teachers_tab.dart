import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/widgets/auth/device_validity.dart';
import 'package:flutter/material.dart';
import '../../../models/filters/teacher.dart';
import '../../../widgets/teacher_grid.dart';
import 'package:provider/provider.dart';

class TeachersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TreePositionBloc<int, ProductSubject>>();

    return StreamBuilder<int>(
      stream: bloc.outCurrentId,
      builder: (context, snapshot) {
        final filter = TeacherFilter(subjectId: snapshot.data);
        return _buildWithFilter(filter);
      }
    );
  }

  Widget _buildWithFilter(TeacherFilter filter) {
    return CommonDeviceValidityWidget(
      validDeviceBuilder: (_) => _buildValidWithFilter(filter),
    );
  }

  Widget _buildValidWithFilter(TeacherFilter filter) {
    return TeacherGrid(filter: filter);
  }
}
