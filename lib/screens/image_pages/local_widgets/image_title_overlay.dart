import 'package:courseplease/models/image.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/overlay.dart';
import 'package:courseplease/widgets/toggle_overlay.dart';
import 'package:flutter/material.dart';

class ImageTitleOverlay extends StatelessWidget {
  final ImageEntity image;
  final bool visible;

  ImageTitleOverlay({
    required this.image,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    if (image.title == '') return Container();

    return Positioned(
      top: 10,
      left: 10,
      child: ToggleOverlay(
        visible: visible,
        child: RoundedOverlay(
          child: Text(
            image.title,
            style: AppStyle.imageTitle,
          ),
        ),
      ),
    );
  }
}
