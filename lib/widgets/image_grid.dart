import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/repositories/photo.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/filters/photo.dart';
import '../models/interfaces.dart';
import '../models/photo.dart';
import 'object_grid.dart';
import '../screens/photo/photo.dart';

abstract class AbstractPhotoGrid<F extends AbstractFilter, R extends AbstractPhotoRepository<F>> extends StatefulWidget {
  final F filter;
  final Axis scrollDirection;
  final SliverGridDelegate gridDelegate;
  final Widget titleIfNotEmpty; // Nullable.

  AbstractPhotoGrid({
    @required this.filter,
    @required this.scrollDirection,
    @required this.gridDelegate,
    this.titleIfNotEmpty,
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
      tileFactory: ({Photo object, int index, TileCallback<int, Photo> onTap}) => PhotoTile(object: object, filter: widget.filter, index: index, onTap: onTap),
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
    );
  }

  @protected
  void handleTap(Photo photo, int index) {}
}

class PhotoTile<F extends AbstractFilter> extends AbstractObjectTile<int, Photo, F> {
  PhotoTile({@required object, @required filter, @required index, TileCallback<int, Photo> onTap}): super(object: object, filter: filter, index: index, onTap: onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(object, index),
      child: Hero(
        tag: 'photo_' + filter.toString() + '_' + object.id.toString(),
        child: Container(
          child: CachedNetworkImage(
            imageUrl: _getUrl(),
            errorWidget: (context, url, error) => Row(children:[Icon(Icons.error), Text(object.id.toString())]),
            fadeInDuration: Duration(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  String _getUrl() {
    return 'https://courseplease.com' + object.urls['300x300'];
  }
}

class GalleryPhotoGrid extends AbstractPhotoGrid<GalleryPhotoFilter, GalleryPhotoRepository> {
  GalleryPhotoGrid({
    @required GalleryPhotoFilter filter,
    @required Axis scrollDirection,
    @required SliverGridDelegate gridDelegate,
    Widget titleIfNotEmpty,
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
  }) : super(
    filter: UnsortedPhotoFilter(),
    scrollDirection: scrollDirection,
    gridDelegate: gridDelegate,
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
}
