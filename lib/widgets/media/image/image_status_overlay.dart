import 'package:courseplease/models/image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../overlay.dart';

class ImageStatusOverlay extends StatelessWidget {
  final ImageEntity object;

  ImageStatusOverlay({
    required this.object,
  });

  @override
  Widget build(BuildContext context) {
    Widget? icon;
    String? text;
    Color? overrideOverlayColor;

    switch (object.status) {
      case ImageStatus.orphan:
        icon = Icon(Icons.error);
        text = tr('models.Image.statuses.noAlbums');
        break;
      case ImageStatus.inconsistent:
        icon = Icon(Icons.error);
        text = tr('models.Image.statuses.inconsistent');
        break;
      case ImageStatus.published:
        break;
      case ImageStatus.unsorted:
        icon = Icon(Icons.visibility_off);
        text = tr('models.Image.statuses.unsorted');
        overrideOverlayColor = Color(0xA000A000);
        break;
      case ImageStatus.review:
        icon = Icon(Icons.hourglass_empty);
        text = tr('models.Image.statuses.review');
        break;
      case ImageStatus.rejected:
        icon = Icon(Icons.cancel);
        text = tr('models.Image.statuses.rejected');
        overrideOverlayColor = Color(0xA0A00000);
        break;
      case ImageStatus.trash:
        icon = Icon(Icons.delete);
        text = tr('models.Image.statuses.trash');
        break;
      default:
        icon = Icon(Icons.error);
        text = tr('models.Image.statuses.unknown');
    }

    if (icon == null && text == null) return Container();

    final widgets = <Widget>[];

    if (icon != null) widgets.add(icon);
    if (text != null) widgets.add(Text(text));

    final child = widgets.length == 1
        ? widgets[0]
        : Row(mainAxisSize: MainAxisSize.min, children: widgets);

    return Positioned(
      top: 0,
      left: 0,
      child: ImageOverlay(
        child: child,
        color: overrideOverlayColor,
      ),
    );
  }
}
