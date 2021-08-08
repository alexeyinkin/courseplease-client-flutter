import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/album_thumb.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/screens/edit_teaching/local_widgets/album_thumb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ImageAlbumThumbWidget extends StatelessWidget {
  final int purposeId;
  final AlbumThumb? thumb;
  final ProductSubject productSubject;
  final VoidCallback onTap;

  ImageAlbumThumbWidget({
    required this.purposeId,
    required this.thumb,
    required this.productSubject,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleKey = ImageAlbumPurpose.requireTitleKey(purposeId, productSubject);
    final titleText = tr('models.Image.purposes.' + titleKey);

    return AlbumThumbWidget(
      titleText: titleText,
      thumb: thumb,
      productSubject: productSubject,
      onTap: onTap,
      emptyIconData: Icons.add_a_photo_outlined,
    );
  }
}
