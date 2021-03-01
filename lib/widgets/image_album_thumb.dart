import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/image_album_thumb.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'overlay.dart';

class ImageAlbumThumbsWidget extends StatelessWidget {
  final Map<int, ImageAlbumThumb> thumbsByPurposeIds;
  final ProductSubject productSubject;
  final ValueChanged<int> onTap;

  ImageAlbumThumbsWidget({
    @required this.thumbsByPurposeIds,
    @required this.productSubject,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final purposeId in thumbsByPurposeIds.keys) {
      children.add(
        ImageAlbumThumbWidget(
          purposeId: purposeId,
          thumb: thumbsByPurposeIds[purposeId],
          productSubject: productSubject,
          onTap: () => _onTap(purposeId),
        ),
      );
    }

    return GridView(
      shrinkWrap: true,
      children: children,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
    );
  }

  void _onTap(int purposeId) {
    if (onTap != null) {
      onTap(purposeId);
    }
  }
}

class ImageAlbumThumbWidget extends StatelessWidget {
  final int purposeId;
  final ImageAlbumThumb thumb; // Nullable
  final ProductSubject productSubject;
  final VoidCallback onTap;

  ImageAlbumThumbWidget({
    @required this.purposeId,
    @required this.thumb,
    @required this.productSubject,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: _getImageWidget(),
          ),
          _getCountOverlay(),
          _getTitleOverlay(context),
        ],
      ),
    );
  }

  Widget _getImageWidget() {
    if (thumb?.lastPublishedImageThumbUrl == null) {
      return Container(
        color: Color(0x40808080),
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
            child: Icon(
              Icons.add_a_photo_outlined,
              color: Color(0x60808080),
            ),
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: 'https://courseplease.com' + thumb.lastPublishedImageThumbUrl,
      errorWidget: (context, url, error) => Icon(Icons.error),//Row(mainAxisSize: MainAxisSize.min,children:[Icon(Icons.error)]),
      fadeInDuration: Duration(),
      fit: BoxFit.cover,
    );
  }

  Widget _getCountOverlay() {
    if (thumb == null || thumb.publishedImageCount == 0) {
      return Container();
    }

    return Positioned.fill(
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            thumb.publishedImageCount.toString(),
            style: TextStyle(
              color: Color(0x80FFFFFF),
              shadows: [
                Shadow(
                  blurRadius: 20,
                  color: Color(0x80000000),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTitleOverlay(BuildContext context) {
    String dateString = null;

    final nameKey = ImageAlbumPurpose.getTitleKeyIfNotTheOnly(purposeId, productSubject);
    final name = nameKey == null ? null : tr('models.Image.purposes.' + nameKey);

    if (thumb?.dateTimeLastPublish != null) {
      dateString = formatShortRoughDuration(
        DateTime.now().difference(thumb.dateTimeLastPublish),
      );
    }

    if (name == null && dateString == null) return Container();

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ImageOverlay(
        child: Row(
          children: [
            Text(name ?? ''),
            Spacer(),
            Text(dateString ?? ''),
          ],
        ),
      ),
    );
  }
}
