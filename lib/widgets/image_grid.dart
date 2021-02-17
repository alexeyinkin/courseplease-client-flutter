import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:courseplease/widgets/auth/auth_provider_icon.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  final SelectableListCubit listStateCubit; // Nullable.
  final bool showMappingsOverlay;

  AbstractImageGrid({
    @required this.filter,
    @required this.scrollDirection,
    @required this.gridDelegate,
    this.titleIfNotEmpty,
    this.listStateCubit,
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
  ImageTile<F> createTile({
    @required ImageEntity object,
    @required int index,
    @required VoidCallback onTap,
    bool selected,
    ValueChanged<bool> onSelected,
  }) {
    final overlays = <Widget>[];

    if (widget.showMappingsOverlay) {
      overlays.add(ImageMappingsOverlay(object: object));
    }

    return ImageTile(
      object: object,
      filter: widget.filter,
      index: index,
      onTap: onTap,
      selectable: widget.listStateCubit != null,
      selected: selected,
      onSelected: onSelected,
      overlays: overlays,
    );
  }
}

class ImageTile<F extends AbstractFilter> extends AbstractObjectTile<int, ImageEntity, F> {
  ImageTile({
    @required object,
    @required filter,
    @required index,
    VoidCallback onTap, // Nullable
    bool selectable = false,
    bool selected = false,
    ValueChanged<bool> onSelected, // Nullable
    List<Widget> overlays = const <Widget>[],
  }) : super(
    object: object,
    filter: filter,
    index: index,
    onTap: onTap,
    selectable: selectable,
    selected: selected,
    onSelected: onSelected,
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

class EditImageGrid extends AbstractImageGrid<EditImageFilter, EditorImageRepository> {
  EditImageGrid({
    @required EditImageFilter filter,
    @required Axis scrollDirection,
    @required SliverGridDelegate gridDelegate,
    SelectableListCubit listStateCubit,
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
        formatRoughDuration(
          DateTime.now().difference(mapping.dateTimeSyncFromRemote),
          AppLocalizations.of(context),
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
