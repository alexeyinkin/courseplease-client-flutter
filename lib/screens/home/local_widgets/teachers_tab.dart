import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/screens/home/local_blocs/teachers_tab.dart';
import 'package:courseplease/screens/home/local_widgets/teachers_filter_button.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/auth/device_validity.dart';
import 'package:easy_localization/easy_localization.dart';
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
      langs:      state.filter.langs,
      search:     state.filter.search,
    );

    return CommonDeviceValidityWidget(
      validDeviceBuilder: (_) => _buildValidWithFilter(state, filter),
    );
  }

  Widget _buildValidWithFilter(TeachersTabCubitState state, TeacherFilter filter) {
    return Column(
      children: [
        _getSearchRow(state),
        Expanded(
          child: TeacherGrid(
            filter: filter,
            productSubject: treePositionState.currentObject,
          ),
        ),
      ],
    );
  }

  Widget _getSearchRow(TeachersTabCubitState state) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: state.searchController,
              labelText: tr('TeachersTabWidget.search'),
            ),
          ),
          TeachersFilterButton(cubit: cubit),
        ],
      ),
    );
  }
}
