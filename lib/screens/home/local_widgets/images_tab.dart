import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/widgets/auth/device_validity.dart';
import 'package:flutter/material.dart';
import '../../../widgets/media/image/gallery_image_grid.dart';
import '../../../models/filters/gallery_image.dart';
import 'package:provider/provider.dart';

class ImagesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TreePositionBloc<int, ProductSubject>>();

    return StreamBuilder<int>(
      stream: bloc.outCurrentId,
      builder: (context, snapshot) {
        final filter = GalleryImageFilter(subjectId: snapshot.data);
        return _buildWithFilter(filter);
      }
    );
  }

  Widget _buildWithFilter(GalleryImageFilter filter) {
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
