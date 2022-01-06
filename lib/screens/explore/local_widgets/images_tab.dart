import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/screens/explore/local_blocs/images_tab.dart';
import 'package:courseplease/screens/home/local_widgets/images_filter_buton.dart';
import 'package:courseplease/widgets/auth/device_validity.dart';
import 'package:flutter/material.dart';
import '../../../widgets/media/image/gallery_image_grid.dart';
import '../../../models/filters/gallery_image.dart';

class ImagesTab extends StatelessWidget {
  final ImagesTabCubit cubit;
  final TreePositionState<int, ProductSubject> treePositionState;

  ImagesTab({
    required this.cubit,
    required this.treePositionState,
  });

  @override
  Widget build(BuildContext context) {
    if (treePositionState.currentId == null) return Container();

    return StreamBuilder<ImagesTabCubitState>(
      stream: cubit.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? cubit.initialState),
    );
  }

  Widget _buildWithState(ImagesTabCubitState state) {
    final filter = GalleryImageFilter(
      subjectId:  treePositionState.currentId,
      purposeId:  ImageAlbumPurpose.portfolio,
      // TODO: Move to a merge() method.
      formats:    state.filter.formats,
      location:   state.filter.location,
      price:      state.filter.price,
      langs:      state.filter.langs,
    );

    return CommonDeviceValidityWidget(
      validDeviceBuilder: (_) => _buildValidWithFilter(filter),
    );
  }

  Widget _buildValidWithFilter(GalleryImageFilter filter) {
    return Stack(
      children: [
        _buildGrid(filter),
        Positioned(
          top: 10,
          right: 10,
          child: ImagesFilterButton(cubit: cubit),
        ),
      ]
    );
  }

  Widget _buildGrid(GalleryImageFilter filter) {
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
