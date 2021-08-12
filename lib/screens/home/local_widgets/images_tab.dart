import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/widgets/auth/device_validity.dart';
import 'package:flutter/material.dart';
import '../../../widgets/media/image/gallery_image_grid.dart';
import '../../../models/filters/gallery_image.dart';

class ImagesTab extends StatelessWidget {
  final TreePositionState<int, ProductSubject> treePositionState;

  ImagesTab({
    required this.treePositionState,
  });

  @override
  Widget build(BuildContext context) {
    if (treePositionState.currentId == null) return Container();
    final filter = GalleryImageFilter(subjectId: treePositionState.currentId);

    return CommonDeviceValidityWidget(
      validDeviceBuilder: (_) => _buildValidWithFilter(filter),
    );
  }

  Widget _buildValidWithFilter(GalleryImageFilter filter) {
    return GalleryImageGrid(
      filter: filter,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
    );
  }
}
