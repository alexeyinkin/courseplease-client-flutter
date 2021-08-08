import 'dart:math';

import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/image.dart';
import 'package:flutter/widgets.dart';

import 'fixed_ids_image_grid.dart';

class ResponsiveImageGrid extends StatelessWidget {
  final IdsSubsetFilter<int, ImageEntity> idsSubsetFilter;
  final double reserveHeight;

  static const _widthFraction = .7;
  static const _maxCrossAxisCount = 5;
  static const _maxMainAxisCount = 3;

  ResponsiveImageGrid({
    required this.idsSubsetFilter,
    required this.reserveHeight,
  });

  @override
  Widget build(BuildContext context) {
    final ids = idsSubsetFilter.ids;
    final screenSize = MediaQuery.of(context).size;
    final maxPreviewWidth = screenSize.width * _widthFraction;
    final crossAxisCount = ids.length <= _maxCrossAxisCount ? ids.length : _maxCrossAxisCount;
    final thumbSize = maxPreviewWidth / crossAxisCount;
    final rows = (ids.length / crossAxisCount).ceil();

    final maxPreviewHeight = rows <= _maxMainAxisCount
        ? thumbSize * rows
        : thumbSize * (_maxMainAxisCount + .5);

    final previewHeight = min(maxPreviewHeight, screenSize.height - reserveHeight);

    var previewWidth = maxPreviewWidth;
    if (previewHeight < thumbSize) {
      previewWidth *= previewHeight / thumbSize * .9; // .9 is to show a little bit of the 2nd row.
    }

    return Container(
      width: previewWidth,
      height: previewHeight,
      child: FixedIdsImageGrid(
        filter: idsSubsetFilter,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
      ),
    );
  }
}
