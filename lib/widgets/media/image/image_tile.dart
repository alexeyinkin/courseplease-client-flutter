import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/widgets/error/id.dart';
import 'package:flutter/material.dart';

import '../../abstract_object_tile.dart';

class ImageTile<F extends AbstractFilter> extends AbstractObjectTile<int, ImageEntity, F> {
  ImageTile({
    required TileCreationRequest<int, ImageEntity, F> request,
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

class ImageTileState<F extends AbstractFilter> extends AbstractObjectTileState<int, ImageEntity, F, ImageTile<F>> {
  @override
  Widget build(BuildContext context) {
    final heroTag = 'image_' + widget.filter.toString() + '_' + widget.object.id.toString();

    return GestureDetector(
      onTap: widget.onTap,
      child: Hero(
        tag: heroTag,
        child: Stack(
          children: [
            _getImageOverlay(),
            Positioned.fill(child: Center(child: Text(widget.object.id.toString()))), // TODO: Delete
            getCheckboxOverlay(),
            ...widget.overlays,
          ],
        ),
      ),
    );
  }

  Widget _getImageOverlay() {
    final imageUrl = _getUrl();

    if (imageUrl == null) {
      return IdErrorWidget(object: widget.object);
    }

    return Positioned.fill(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        errorWidget: (context, url, error) => IdErrorWidget(object: widget.object),
        fadeInDuration: Duration(),
        fit: BoxFit.cover,
      ),
    );
  }

  String? _getUrl() {
    final urlPath = widget.object.urls['300x300'];
    if (urlPath == null) return null;
    return 'https://courseplease.com' + urlPath;
  }
}
