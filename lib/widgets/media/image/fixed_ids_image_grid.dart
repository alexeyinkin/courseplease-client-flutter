import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/screens/image_pages/image_pages.dart';
import 'package:flutter/widgets.dart';

import 'image_grid.dart';

class FixedIdsImageGrid extends AbstractImageGrid<
  IdsSubsetFilter<int, ImageEntity>,
  AbstractImageRepository<IdsSubsetFilter<int, ImageEntity>>
> {
  FixedIdsImageGrid({
    required IdsSubsetFilter<int, ImageEntity> filter,
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
  State<AbstractImageGrid> createState() => _FixedIdsImageGridState();
}

class _FixedIdsImageGridState extends AbstractImageGridState<
  IdsSubsetFilter<int, ImageEntity>,
  AbstractImageRepository<IdsSubsetFilter<int, ImageEntity>>
> {
  @override
  void handleTap(ImageEntity image, int index) {
    ImagePagesScreenLauncher.showWithTitles<IdsSubsetFilter<int, ImageEntity>, AbstractImageRepository<IdsSubsetFilter<int, ImageEntity>>>(
      context: context,
      filter: widget.filter,
      initialIndex: index,
    );
  }
}
