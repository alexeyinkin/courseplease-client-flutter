import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/blocs/selection.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/repositories/photo.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:courseplease/widgets/auth/auth_provider_icon.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/filters/photo.dart';
import '../models/interfaces.dart';
import '../models/photo.dart';
import 'object_grid.dart';
import '../screens/photo/photo.dart';
import 'overlay.dart';

abstract class AbstractPhotoGrid<F extends AbstractFilter, R extends AbstractPhotoRepository<F>> extends StatefulWidget {
  final F filter;
  final Axis scrollDirection;
  final SliverGridDelegate gridDelegate;
  final Widget titleIfNotEmpty; // Nullable.
  final SelectionCubit selectionCubit; // Nullable.

  AbstractPhotoGrid({
    @required this.filter,
    @required this.scrollDirection,
    @required this.gridDelegate,
    this.titleIfNotEmpty,
    this.selectionCubit,
  }) : super(key: ValueKey(filter.toString()));

  bool isFilterValid(F filter) {
    return true;
  }
}

class AbstractPhotoGridState<F extends AbstractFilter, R extends AbstractPhotoRepository<F>> extends State<AbstractPhotoGrid> {
  @override
  Widget build(BuildContext context) {
    return widget.isFilterValid(widget.filter)
        ? _buildWithFilter()
        : Container();
  }

  Widget _buildWithFilter() {
    return ObjectGrid<int, Photo, F, R, PhotoTile<F>>(
      filter: widget.filter,
      tileFactory: createTile,
      titleIfNotEmpty: widget.titleIfNotEmpty,

      // When using Photo as argument type, for some reason an exception is thrown
      // at tile construction in ObjectGird in GridView.builder:
      //
      // type '(Photo, int) => Null' is not a subtype of type '(WithId<dynamic>, int) => void'
      // TODO: Find the reason for the exception, change the argument type to Photo.
      onTap: (WithId photo, int index) {
        if (photo is Photo) {
          handleTap(photo, index);
        } else {
          throw Exception('A photo is not Photo');
        }
      },
      scrollDirection: widget.scrollDirection,
      gridDelegate: widget.gridDelegate,
      selectionCubit: widget.selectionCubit,
    );
  }

  @protected
  void handleTap(Photo photo, int index) {}

  @protected
  PhotoTile<F> createTile({
    @required Photo object,
    @required int index,
    @required VoidCallback onTap,
    bool selected,
    ValueChanged<bool> onSelected,
  }) {
    return PhotoTile(
      object: object,
      filter: widget.filter,
      index: index,
      onTap: onTap,
      selected: selected,
      onSelected: onSelected,
    );
  }
}

class PhotoTile<F extends AbstractFilter> extends AbstractObjectTile<int, Photo, F> {
  PhotoTile({
    @required object,
    @required filter,
    @required index,
    VoidCallback onTap, // Nullable
    bool selectable = false,
    bool selected = false,
    ValueChanged<bool> onSelected, // Nullable
  }) : super(
    object: object,
    filter: filter,
    index: index,
    onTap: onTap,
    selectable: selectable,
    selected: selected,
    onSelected: onSelected,
  );

  @override
  State<AbstractObjectTile> createState() => PhotoTileState<F>();
}

class PhotoTileState<F extends AbstractFilter> extends AbstractObjectTileState<int, Photo, F> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Hero(
        tag: 'photo_' + widget.filter.toString() + '_' + widget.object.id.toString(),
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
            ...buildOverlays(context),
          ],
        ),
      ),
    );
  }

  String _getUrl() {
    return 'https://courseplease.com' + widget.object.urls['300x300'];
  }

  @protected
  List<Widget> buildOverlays(BuildContext context) {
    return <Widget>[];
  }
}

class GalleryPhotoGrid extends AbstractPhotoGrid<GalleryPhotoFilter, GalleryPhotoRepository> {
  GalleryPhotoGrid({
    @required GalleryPhotoFilter filter,
    @required Axis scrollDirection,
    @required SliverGridDelegate gridDelegate,
    Widget titleIfNotEmpty, // Nullable
  }) : super(
    filter: filter,
    scrollDirection: scrollDirection,
    gridDelegate: gridDelegate,
    titleIfNotEmpty: titleIfNotEmpty,
  );

  @override
  State<AbstractPhotoGrid> createState() => GalleryPhotoGridState();

  @override
  bool isFilterValid(GalleryPhotoFilter filter) {
    return filter.subjectId != null;
  }
}

class GalleryPhotoGridState extends AbstractPhotoGridState<GalleryPhotoFilter, GalleryPhotoRepository> {
  @override
  void handleTap(Photo photo, int index) {
    Navigator.of(context).pushNamed(
      GalleryPhotoLightboxScreen.routeName,
      arguments: PhotoLightboxArguments<GalleryPhotoFilter>(
        filter: widget.filter,
        index: index,
      ),
    );
  }
}

class UnsortedPhotoGrid extends AbstractPhotoGrid<UnsortedPhotoFilter, UnsortedPhotoRepository> {
  UnsortedPhotoGrid({
    @required Axis scrollDirection,
    @required SliverGridDelegate gridDelegate,
    @required SelectionCubit selectionCubit,
  }) : super(
    filter: UnsortedPhotoFilter(),
    scrollDirection: scrollDirection,
    gridDelegate: gridDelegate,
    selectionCubit: selectionCubit,
  );

  @override
  State<AbstractPhotoGrid> createState() => UnsortedPhotoGridState();
}

class UnsortedPhotoGridState extends AbstractPhotoGridState<UnsortedPhotoFilter, UnsortedPhotoRepository> {
  @override
  void handleTap(Photo photo, int index) {
    Navigator.of(context).pushNamed(
      UnsortedPhotoLightboxScreen.routeName,
      arguments: PhotoLightboxArguments<UnsortedPhotoFilter>(
        filter: widget.filter,
        index: index,
      ),
    );
  }

  @protected
  UnsortedPhotoTile createTile({
    @required Photo object,
    @required int index,
    @required VoidCallback onTap,
    @required bool selected,
    @required ValueChanged<bool> onSelected,
  }) {
    return UnsortedPhotoTile(
      object: object,
      filter: widget.filter,
      index: index,
      onTap: onTap,
      selected: selected,
      onSelected: onSelected,
    );
  }
}

class UnsortedPhotoTile extends PhotoTile<UnsortedPhotoFilter> {
  UnsortedPhotoTile({
    @required Photo object,
    @required UnsortedPhotoFilter filter,
    @required int index,
    VoidCallback onTap, // Nullable
    @required bool selected,
    @required ValueChanged<bool> onSelected,
  }) : super(
    object: object,
    filter: filter,
    index: index,
    onTap: onTap,
    selectable: true,
    selected: selected,
    onSelected: onSelected,
  );

  @override
  State<AbstractObjectTile> createState() => UnsortedPhotoTileState();
}

class UnsortedPhotoTileState extends PhotoTileState<UnsortedPhotoFilter> {
  @override
  List<Widget> buildOverlays(BuildContext context) {
    return [
      _getOriginOverlay(),
    ];
  }

  Widget _getOriginOverlay() {
    if (widget.object.mappings.isEmpty) return Container();
    final mapping = widget.object.mappings[0];

    final icon = mapping.classShortIntName == null
        ? Container()
        : padRight(AuthProviderIcon(name: mapping.classShortIntName, scale: .5));

    final timeAgo = mapping.dateTimeSyncFromRemote == null
        ? ''
        : formatTimeAgo(DateTime.now().difference(mapping.dateTimeSyncFromRemote), AppLocalizations.of(context));

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ImageOverlay(
        child: Row(
          children: [
            icon,
            Text(timeAgo),
          ],
        ),
      ),
    );
  }
}
