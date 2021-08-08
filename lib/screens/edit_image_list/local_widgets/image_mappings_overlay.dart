import 'package:courseplease/models/image.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/auth/auth_provider_icon.dart';
import 'package:courseplease/widgets/overlay.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/widgets.dart';

class ImageMappingsOverlay extends StatelessWidget {
  final ImageEntity object;

  ImageMappingsOverlay({
    required this.object,
  });

  @override
  Widget build(BuildContext context) {
    if (object.mappings.isEmpty) return Container();

    final children = <Widget>[];
    final mapping = object.mappings[0];

    if (mapping.classShortIntName != null) {
      children.add(AuthProviderIcon(name: mapping.classShortIntName!, scale: .5));
      children.add(SmallPadding());
    }

    final textParts = <String>[];

    if (mapping.contactUsername != null) {
      textParts.add(mapping.contactUsername!);
    }

    if (mapping.dateTimeSyncFromRemote != null) {
      textParts.add(
        formatShortRoughDuration(
          DateTime.now().difference(mapping.dateTimeSyncFromRemote!),
        ),
      );
    }

    children.add(Text(textParts.join(' · ')));

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ImageOverlay(
        child: Row(
          children: children,
        ),
      ),
    );
  }
}
