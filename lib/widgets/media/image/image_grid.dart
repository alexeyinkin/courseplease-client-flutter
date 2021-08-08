import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/screens/edit_image_list/local_widgets/image_mappings_overlay.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../models/image.dart';
import '../../object_grid.dart';
import 'image_status_overlay.dart';
import 'image_tile.dart';

abstract class AbstractImageGrid<F extends AbstractFilter, R extends AbstractImageRepository<F>> extends StatefulWidget {
  final F filter;
  final Axis scrollDirection;
  final SliverGridDelegate gridDelegate;
  final Widget? titleIfNotEmpty;
  final SelectableListCubit<int, F>? listStateCubit;
  final bool showStatusOverlay;
  final bool showMappingsOverlay;

  AbstractImageGrid({
    required this.filter,
    required this.scrollDirection,
    required this.gridDelegate,
    this.titleIfNotEmpty,
    this.listStateCubit,
    this.showStatusOverlay = false,
    this.showMappingsOverlay = false,
  }) : super(key: ValueKey(filter.toString()));

  bool isFilterValid(F filter) {
    return true;
  }
}

class AbstractImageGridState<F extends AbstractFilter, R extends AbstractImageRepository<F>> extends State<AbstractImageGrid<F, R>> {
  @override
  Widget build(BuildContext context) {
    return widget.isFilterValid(widget.filter)
        ? _buildWithFilter()
        : Container();
  }

  Widget _buildWithFilter() {
    return ObjectGrid<int, ImageEntity, F, R, ImageTile<F>>(
      filter: widget.filter,
      tileFactory: createTile,
      titleIfNotEmpty: widget.titleIfNotEmpty,
      onTap: handleTap,
      scrollDirection: widget.scrollDirection,
      gridDelegate: widget.gridDelegate,
      listStateCubit: widget.listStateCubit,
    );
  }

  @protected
  void handleTap(ImageEntity image, int index) {}

  @protected
  ImageTile<F> createTile(TileCreationRequest<int, ImageEntity, F> request) {
    final overlays = <Widget>[];

    if (widget.showMappingsOverlay) {
      overlays.add(ImageMappingsOverlay(object: request.object));
    }

    if (widget.showMappingsOverlay) {
      overlays.add(ImageStatusOverlay(object: request.object));
    }

    return ImageTile(
      request: request,
      selectable: widget.listStateCubit != null,
      overlays: overlays,
    );
  }
}
