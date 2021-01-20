import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/repositories/photo.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:flutter/material.dart';
import '../models/filters/photo.dart';
import '../models/interfaces.dart';
import '../models/photo.dart';
import 'object_grid.dart';
import '../screens/photo/photo.dart';

class PhotoGrid extends StatefulWidget {
  final PhotoFilter filter;
  final Axis scrollDirection;
  final SliverGridDelegate gridDelegate;
  final Widget titleIfNotEmpty; // Nullable.

  PhotoGrid({
    @required this.filter,
    @required this.scrollDirection,
    @required this.gridDelegate,
    this.titleIfNotEmpty,
  }) : super(key: ValueKey(filter.toString()));

  @override
  State<PhotoGrid> createState() {
    return new PhotoGridState();
  }
}

class PhotoGridState extends State<PhotoGrid> {
  @override
  Widget build(BuildContext context) {
    return _isFilterValid(widget.filter)
        ? _buildWithFilter()
        : Container();
  }

  static bool _isFilterValid(PhotoFilter filter) {
    return filter.subjectId != null;
  }

  Widget _buildWithFilter() {
    return ObjectGrid<int, Photo, PhotoFilter, PhotoRepository, PhotoTile>(
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
          _handleTap(photo, index);
        } else {
          throw Exception('A photo is not Photo');
        }
      },
      scrollDirection: widget.scrollDirection,
      gridDelegate: widget.gridDelegate,
    );
  }

  void _handleTap(Photo photo, int index) {
    Navigator.of(context).pushNamed(
      PhotoLightboxScreen.routeName,
      arguments: PhotoLightboxArguments(
        filter: widget.filter,
        index: index,
      ),
    );
  }
}

class PhotoTile extends AbstractObjectTile<int, Photo, PhotoFilter> {
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
