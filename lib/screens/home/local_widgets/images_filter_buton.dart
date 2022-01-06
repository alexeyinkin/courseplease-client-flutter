import 'package:courseplease/models/filters/gallery_image.dart';
import 'package:courseplease/screens/explore/local_blocs/images_tab.dart';
import 'package:courseplease/screens/filter/local_blocs/gallery_image_filter.dart';
import 'package:courseplease/screens/filter/local_widgets/gallery_image_filter.dart';
import 'package:courseplease/services/filter_buttons/gallery_image_filter.dart';
import 'package:courseplease/widgets/filter_button.dart';
import 'package:flutter/material.dart';

class ImagesFilterButton extends StatelessWidget {
  final ImagesTabCubit cubit;

  ImagesFilterButton({
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return FilterButton<GalleryImageFilter, GalleryImageFilterDialogCubit>(
      filterableCubit: cubit,
      filterButtonService: GalleryImageFilterButtonService(),
      dialogContentCubitFactory: () => GalleryImageFilterDialogCubit(),
      dialogContentBuilder: (context, cubit) => GalleryImageFilterDialogContentWidget(cubit: cubit),
      style: FilterButtonStyle.elevated,
    );
  }
}
