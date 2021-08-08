import 'package:courseplease/models/album_thumb.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/screens/edit_teaching/local_widgets/lessons_thumb.dart';
import 'package:courseplease/widgets/media/image/image_album_thumb.dart';
import 'package:flutter/material.dart';

class AlbumThumbsWidget extends StatelessWidget {
  final Map<int, AlbumThumb?> thumbsByPurposeIds;
  final ProductSubject productSubject;
  final ValueChanged<int>? onTap;

  AlbumThumbsWidget({
    required this.thumbsByPurposeIds,
    required this.productSubject,
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

    children.add(
      LessonsThumbWidget(
        productSubject: productSubject,
      ),
    );

    return GridView(
      shrinkWrap: true,
      children: children,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
    );
  }

  void _onTap(int purposeId) {
    if (onTap != null) {
      onTap!(purposeId);
    }
  }
}
