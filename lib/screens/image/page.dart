import 'package:app_state/app_state.dart';
import 'package:courseplease/models/filters/gallery_image.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/screens/image/configurations.dart';
import 'package:courseplease/screens/image/screen.dart';
import 'package:flutter/foundation.dart';

class ImagePage extends StatelessMaterialPage<AppConfiguration> {
  ImagePage({
    required GalleryImageFilter filter,
    required ProductSubject productSubject,
    required int imageId,
  }) : super(
    key: ValueKey('ImagePage_$imageId'),
    child: ImageScreen(imageId: imageId),
    configuration: ImageConfiguration(
      filter: filter,
      productSubject: productSubject,
      id: imageId,
    ),
  );
}
