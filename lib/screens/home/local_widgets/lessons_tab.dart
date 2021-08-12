import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/widgets/auth/device_validity.dart';
import 'package:flutter/material.dart';
import '../../../widgets/lesson/gallery_lesson_grid.dart';
import '../../../models/filters/gallery_lesson.dart';

class LessonsTab extends StatelessWidget {
  final TreePositionState<int, ProductSubject> treePositionState;

  LessonsTab({
    required this.treePositionState,
  });

  @override
  Widget build(BuildContext context) {
    if (treePositionState.currentId == null) return Container();
    final filter = GalleryLessonFilter(subjectId: treePositionState.currentId);

    return CommonDeviceValidityWidget(
      validDeviceBuilder: (_) => _buildValidWithFilter(filter),
    );
  }

  Widget _buildValidWithFilter(GalleryLessonFilter filter) {
    return GalleryLessonGrid(
      filter: filter,
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
    );
  }
}
