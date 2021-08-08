import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/my_image.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/screens/image_pages/image_pages.dart';
import 'package:flutter/widgets.dart';

import 'image_grid.dart';

class MyImageGrid extends AbstractImageGrid<MyImageFilter, MyImageRepository> {
  MyImageGrid({
    required MyImageFilter filter,
    required Axis scrollDirection,
    required SliverGridDelegate gridDelegate,
    SelectableListCubit<int, MyImageFilter>? listStateCubit,
    bool showStatusOverlay = false,
    bool showMappingsOverlay = false,
  }) : super(
    filter: filter,
    scrollDirection: scrollDirection,
    gridDelegate: gridDelegate,
    listStateCubit: listStateCubit,
    showMappingsOverlay: showMappingsOverlay,
  );

  @override
  State<AbstractImageGrid> createState() => _MyImageGridState();
}

class _MyImageGridState extends AbstractImageGridState<MyImageFilter, MyImageRepository> {
  @override
  void handleTap(ImageEntity image, int index) {
    ImagePagesScreenLauncher.showWithTitles<MyImageFilter, MyImageRepository>(
      context: context,
      filter: widget.filter,
      initialIndex: index,
    );
  }
}
