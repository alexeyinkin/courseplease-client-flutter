import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/widgets/auth/device_validity.dart';
import 'package:flutter/material.dart';
import '../../../models/filters/teacher.dart';
import '../../../widgets/teacher_grid.dart';

class TeachersTab extends StatelessWidget {
  final TreePositionState<int, ProductSubject> treePositionState;

  TeachersTab({
    required this.treePositionState,
  });

  @override
  Widget build(BuildContext context) {
    if (treePositionState.currentId == null) return Container();
    final filter = TeacherFilter(subjectId: treePositionState.currentId);

    return CommonDeviceValidityWidget(
      validDeviceBuilder: (_) => _buildValidWithFilter(filter),
    );
  }

  Widget _buildValidWithFilter(TeacherFilter filter) {
    return TeacherGrid(
      filter: filter,
      productSubject: treePositionState.currentObject,
    );
  }
}
