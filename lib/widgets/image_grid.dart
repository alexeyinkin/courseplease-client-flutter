import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:courseplease/widgets/auth/auth_provider_icon.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/filters/image.dart';
import '../models/interfaces.dart';
import '../models/image.dart';
import 'object_grid.dart';
import '../screens/image/image.dart';
import 'overlay.dart';

abstract class AbstractImageGrid<F extends AbstractFilter, R extends AbstractImageRepository<F>> extends StatefulWidget {
  final F filter;
  final Axis scrollDirection;
  final SliverGridDelegate gridDelegate;
  final Widget titleIfNotEmpty; // Nullable.
  final SelectableListCubit<int, F> listStateCubit; // Nullable.
  final bool showStatusOverlay;
  final bool showMappingsOverlay;

  AbstractImageGrid({
    @required this.filter,
    @required this.scrollDirection,
    @required this.gridDelegate,
    this.titleIfNotEmpty,
    this.listStateCubit,
    this.showStatusOverlay = false,
    this.showMappingsOverlay = false,
  }) : super(key: ValueKey(filter.toString()));

  bool isFilterValid(F filter) {
    return true;
  }
}

class AbstractImageGridState<F extends AbstractFilter, R extends AbstractImageRepository<F>> extends State<AbstractImageGrid> {
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

      // When using ImageEntity as argument type, for some reason an exception is thrown
      // at tile construction in ObjectGird in GridView.builder:
      //
      // type '(ImageEntity, int) => Null' is not a subtype of type '(WithId<dynamic>, int) => void'
      // TODO: Find the reason for the exception, change the argument type to the actual model.
      onTap: (WithId image, int index) {
        if (image is ImageEntity) {
          handleTap(image, index);
        } else {
          throw Exception('An image is not ImageEntity');
        }
      },
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

class ImageTile<F extends AbstractFilter> extends AbstractObjectTile<int, ImageEntity, F> {
  ImageTile({
    @required TileCreationRequest<int, ImageEntity, F> request,
    bool selectable = false,
    List<Widget> overlays = const <Widget>[],
  }) : super(
    request: request,
    selectable: selectable,
    overlays: overlays,
  );

  @override
  State<AbstractObjectTile> createState() => ImageTileState<F>();
}

class ImageTileState<F extends AbstractFilter> extends AbstractObjectTileState<int, ImageEntity, F> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Hero(
        tag: 'image_' + widget.filter.toString() + '_' + widget.object.id.toString(),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: _getUrl(),
                errorWidget: (context, url, error) => Row(children:[Icon(Icons.error), Text(widget.object.id.toString())]),
                fadeInDuration: Duration(),
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(child: Center(child: Text(widget.object.id.toString()))), // TODO: Delete
            getCheckboxOverlay(),
            ...widget.overlays,
          ],
        ),
      ),
    );
  }

  String _getUrl() {
    return 'https://courseplease.com' + widget.object.urls['300x300'];
  }
}

class ViewImageGrid extends AbstractImageGrid<ViewImageFilter, GalleryImageRepository> {
  ViewImageGrid({
    @required ViewImageFilter filter,
    @required Axis scrollDirection,
    @required SliverGridDelegate gridDelegate,
    Widget titleIfNotEmpty, // Nullable
    bool showMappingsOverlay = false,
  }) : super(
    filter: filter,
    scrollDirection: scrollDirection,
    gridDelegate: gridDelegate,
    titleIfNotEmpty: titleIfNotEmpty,
    showMappingsOverlay: showMappingsOverlay,
  );

  @override
  State<AbstractImageGrid> createState() => ViewImageGridState();

  @override
  bool isFilterValid(ViewImageFilter filter) {
    return filter.subjectId != null;
  }
}

class ViewImageGridState extends AbstractImageGridState<ViewImageFilter, GalleryImageRepository> {
  @override
  void handleTap(ImageEntity image, int index) {
    Navigator.of(context).pushNamed(
      ViewImageLightboxScreen.routeName,
      arguments: ImageLightboxArguments<ViewImageFilter>(
        filter: widget.filter,
        index: index,
      ),
    );
  }
}

class FixedIdsImageGrid extends AbstractImageGrid<
  IdsSubsetFilter<int, ImageEntity>,
  AbstractImageRepository<IdsSubsetFilter<int, ImageEntity>>
> {
  FixedIdsImageGrid({
    @required IdsSubsetFilter<int, ImageEntity> filter,
    @required Axis scrollDirection,
    @required SliverGridDelegate gridDelegate,
    Widget titleIfNotEmpty, // Nullable
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
    Navigator.of(context).pushNamed(
      FixedIdsImageLightboxScreen.routeName,
      arguments: ImageLightboxArguments<IdsSubsetFilter<int, ImageEntity>>(
        filter: widget.filter,
        index: index,
      ),
    );
  }
}

class EditImageGrid extends AbstractImageGrid<EditImageFilter, EditorImageRepository> {
  EditImageGrid({
    @required EditImageFilter filter,
    @required Axis scrollDirection,
    @required SliverGridDelegate gridDelegate,
    SelectableListCubit<int, EditImageFilter> listStateCubit,
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
  State<AbstractImageGrid> createState() => EditImageGridState();
}

class EditImageGridState extends AbstractImageGridState<EditImageFilter, EditorImageRepository> {
  @override
  void handleTap(ImageEntity image, int index) {
    Navigator.of(context).pushNamed(
      EditImageLightboxScreen.routeName,
      arguments: ImageLightboxArguments<EditImageFilter>(
        filter: widget.filter,
        index: index,
      ),
    );
  }
}

class ImageMappingsOverlay extends StatelessWidget {
  final ImageEntity object;

  ImageMappingsOverlay({
    @required this.object,
  });

  @override
  Widget build(BuildContext context) {
    if (object.mappings.isEmpty) return Container();
    final mapping = object.mappings[0];

    final icon = mapping.classShortIntName == null
        ? Container()
        : padRight(AuthProviderIcon(name: mapping.classShortIntName, scale: .5));

    final textParts = <String>[];

    if (mapping.contactUsername != null) {
      textParts.add(mapping.contactUsername);
    }

    if (mapping.dateTimeSyncFromRemote != null) {
      textParts.add(
        formatShortRoughDuration(
          DateTime.now().difference(mapping.dateTimeSyncFromRemote),
        ),
      );
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ImageOverlay(
        child: Row(
          children: [
            icon,
            Text(textParts.join(' · ')),
          ],
        ),
      ),
    );
  }
}

class ImageStatusOverlay extends StatelessWidget {
  final ImageEntity object;

  ImageStatusOverlay({
    @required this.object,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = null;
    String text = null;
    Color overrideOverlayColor = null;

    switch (object.status) {
      case ImageStatus.orphan:
        icon = Icon(Icons.error);
        text = tr('models.Image.statuses.noAlbums');
        break;
      case ImageStatus.inconsistent:
        icon = Icon(Icons.error);
        text = tr('models.Image.statuses.inconsistent');
        break;
      case ImageStatus.published:
        break;
      case ImageStatus.unsorted:
        icon = Icon(Icons.visibility_off);
        text = tr('models.Image.statuses.unsorted');
        overrideOverlayColor = Color(0xA000A000);
        break;
      case ImageStatus.review:
        icon = Icon(Icons.hourglass_empty);
        text = tr('models.Image.statuses.review');
        break;
      case ImageStatus.rejected:
        icon = Icon(Icons.cancel);
        text = tr('models.Image.statuses.rejected');
        overrideOverlayColor = Color(0xA0A00000);
        break;
      case ImageStatus.trash:
        icon = Icon(Icons.delete);
        text = tr('models.Image.statuses.trash');
        break;
      default:
        icon = Icon(Icons.error);
        text = tr('models.Image.statuses.unknown');
    }

    if (icon == null && text == null) return Container();

    final widgets = <Widget>[];

    if (icon != null) widgets.add(icon);
    if (text != null) widgets.add(Text(text));

    final child = widgets.length == 1
        ? widgets[0]
        : Row(mainAxisSize: MainAxisSize.min, children: widgets);

    return Positioned(
      top: 0,
      left: 0,
      child: ImageOverlay(
        child: child,
        color: overrideOverlayColor,
      ),
    );
  }
}

class ResponsiveImageGrid extends StatelessWidget {
  final IdsSubsetFilter<int, ImageEntity> idsSubsetFilter;
  final double reserveHeight;

  static const _widthFraction = .7;
  static const _maxCrossAxisCount = 5;
  static const _maxMainAxisCount = 3;

  ResponsiveImageGrid({
    @required this.idsSubsetFilter,
    @required this.reserveHeight,
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
