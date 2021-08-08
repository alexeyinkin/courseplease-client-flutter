import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/models/album_thumb.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AlbumThumbWidget extends StatelessWidget {
  final String? titleText;
  final AlbumThumb? thumb;
  final ProductSubject productSubject;
  final VoidCallback onTap;
  final IconData emptyIconData;

  AlbumThumbWidget({
    required this.titleText,
    required this.thumb,
    required this.productSubject,
    required this.onTap,
    required this.emptyIconData,
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
    final lastPublishedImageThumbUrl = thumb?.lastPublishedImageThumbUrl;

    if (lastPublishedImageThumbUrl == null) {
      return Container(
        color: Color(0x40808080),
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
            child: Icon(
              emptyIconData,
              color: Color(0x60808080),
            ),
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: 'https://courseplease.com' + lastPublishedImageThumbUrl,
      errorWidget: (context, url, error) => Icon(Icons.error),
      fadeInDuration: Duration(),
      fit: BoxFit.cover,
    );
  }

  Widget _getCountOverlay() {
    final count = thumb?.publishedImageCount ?? 0;

    if (count == 0) {
      return Container();
    }

    return Positioned.fill(
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            count.toString(),
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
    final dateString = _getDateString();

    if (titleText == null && dateString == null) return Container();

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ImageOverlay(
        child: Row(
          children: [
            Text(titleText ?? ''),
            Spacer(),
            Text(dateString ?? ''),
          ],
        ),
      ),
    );
  }

  String? _getDateString() {
    final dt = thumb?.dateTimeLastPublish;
    if (dt == null) return null;

    return formatShortRoughDuration(
      DateTime.now().difference(dt),
    );
  }
}
