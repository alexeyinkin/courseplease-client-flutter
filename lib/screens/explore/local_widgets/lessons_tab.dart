import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/screens/explore/local_blocs/lessons_tab.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/auth/device_validity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../widgets/lesson/gallery_lesson_grid.dart';
import '../../../models/filters/gallery_lesson.dart';
import '../../home/local_widgets/lessons_filter_button.dart';

class LessonsTab extends StatelessWidget {
  final LessonsTabCubit cubit;
  final TreePositionState<int, ProductSubject> treePositionState;

  LessonsTab({
    required this.cubit,
    required this.treePositionState,
  });

  @override
  Widget build(BuildContext context) {
    if (treePositionState.currentId == null) return Container();

    return StreamBuilder<LessonsTabCubitState>(
      stream: cubit.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? cubit.initialState),
    );
  }

  Widget _buildWithState(LessonsTabCubitState state) {
    if (treePositionState.currentId == null) return Container();
    final filter = GalleryLessonFilter(
      subjectId:  treePositionState.currentId,
      // TODO: Move to a merge() method.
      langs:      state.filter.langs,
      search:     state.filter.search,
    );

    return CommonDeviceValidityWidget(
      validDeviceBuilder: (_) => _buildValidWithFilter(state, filter),
    );
  }

  Widget _buildValidWithFilter(LessonsTabCubitState state, GalleryLessonFilter filter) {
    return Column(
      children: [
        _getSearchRow(state),
        Expanded(
          child: GalleryLessonGrid(
            filter: filter,
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
          ),
        ),
      ],
    );
  }

  Widget _getSearchRow(LessonsTabCubitState state) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: state.searchController,
              labelText: tr('LessonsTabWidget.search'),
            ),
          ),
          LessonsFilterButton(cubit: cubit),
        ],
      ),
    );
  }
}
