import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/reaction/enum/like_catalog_intname.dart';
import 'package:courseplease/services/reload/image.dart';
import 'package:courseplease/widgets/reaction/reaction_buttons.dart';
import 'package:courseplease/widgets/toggle_overlay.dart';
import 'package:flutter/material.dart';

class ImageReactionOverlay extends StatelessWidget {
  final ImageEntity image;
  final bool visible;
  final VoidCallback? onCommentPressed;

  ImageReactionOverlay({
    required this.image,
    required this.visible,
    required this.onCommentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      bottom: 10,
      child: ToggleOverlay(
        visible: visible,
        child: ReactionButtons(
          commentable: image,
          onCommentPressed: onCommentPressed,
          likable: image,
          catalog: LikeCatalogIntNameEnum.photos,
          reloadCallback: () => ImageReloadService().reload(image.id),
          isMy: image.authorId == getCurrentUserId(),
        ),
      ),
    );
  }
}
