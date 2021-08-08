import 'package:courseplease/models/filters/gallery_image.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/screens/image_pages/image_pages.dart';
import 'package:flutter/widgets.dart';

import 'image_grid.dart';

class GalleryImageGrid extends AbstractImageGrid<GalleryImageFilter, GalleryImageRepository> {
  GalleryImageGrid({
    required GalleryImageFilter filter,
    required Axis scrollDirection,
    required SliverGridDelegate gridDelegate,
    Widget? titleIfNotEmpty,
    bool showMappingsOverlay = false,
  }) : super(
    filter: filter,
    scrollDirection: scrollDirection,
    gridDelegate: gridDelegate,
    titleIfNotEmpty: titleIfNotEmpty,
    showMappingsOverlay: showMappingsOverlay,
  );

  @override
  State<AbstractImageGrid> createState() => GalleryImageGridState();

  @override
  bool isFilterValid(GalleryImageFilter filter) {
    return filter.subjectId != null;
  }
}

class GalleryImageGridState extends AbstractImageGridState<GalleryImageFilter, GalleryImageRepository> {
  @override
  void handleTap(ImageEntity image, int index) {
    ViewImagePagesScreenLauncher.show(
      context: context,
      filter: widget.filter,
      initialIndex: index,
    );
  }
}
