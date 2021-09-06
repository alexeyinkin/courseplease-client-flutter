import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/screens/home/local_blocs/teachers_tab.dart';
import 'package:courseplease/widgets/auth/device_validity.dart';
import 'package:flutter/material.dart';
import '../../../models/filters/teacher.dart';
import '../../../widgets/teacher_grid.dart';

class TeachersTab extends StatelessWidget {
  final TeachersTabCubit cubit;
  final TreePositionState<int, ProductSubject> treePositionState;

  TeachersTab({
    required this.cubit,
    required this.treePositionState,
  });

  @override
  Widget build(BuildContext context) {
    if (treePositionState.currentId == null) return Container();

    return StreamBuilder<TeachersTabCubitState>(
      stream: cubit.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? cubit.initialState),
    );
  }

  Widget _buildWithState(TeachersTabCubitState state) {
    final filter = TeacherFilter(
      subjectId: treePositionState.currentId,
      // TODO: Move to a merge() method.
      formats:    state.filter.formats,
      location:   state.filter.location,
      price:      state.filter.price,
    );

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
