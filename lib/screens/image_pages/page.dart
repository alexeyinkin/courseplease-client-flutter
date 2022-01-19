import 'package:app_state/app_state.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/filters/gallery_image.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/image_pages/screen.dart';
import 'package:flutter/foundation.dart';

import 'bloc.dart';

class ImagePagesGalleryPage extends BlocMaterialPage<
  MyPageConfiguration,
  ImagePagesGalleryBloc
> {
  static const factoryKey = 'ImagePagesGalleryPage';

  ImagePagesGalleryPage({
    required GalleryImageFilter filter,
    required int initialIndex,
    required int initialId,
  }) : super(
    key: ValueKey(formatKey(filter: filter)),
    bloc: ImagePagesGalleryBloc(
      filter: filter,
      initialIndex: initialIndex,
      initialId: initialId,
    ),
    createScreen: (b) => ImagePagesGalleryScreen(bloc: b),
  );

  static String formatKey({required GalleryImageFilter filter}) {
    return '${factoryKey}_$filter';
  }
}

class ImagePagesTitlesPage<
  F extends AbstractFilter,
  R extends AbstractImageRepository<F>
> extends BlocMaterialPage<
  MyPageConfiguration,
  ImagePagesTitlesBloc<F, R>
> {
  ImagePagesTitlesPage({
    required F filter,
    required int initialIndex,
    required int initialId,
  }) : super(
    // TODO: Disregard initialIndex for filter, navigate to index
    //       if another instance of the page with another index
    //       is brought to front.
    key: ValueKey('ImagePagesTitlesPage_${filter}_$initialIndex'),
    bloc: ImagePagesTitlesBloc<F, R>(
      filter: filter,
      initialIndex: initialIndex,
      initialId: initialId,
    ),
    createScreen: (b) => ImagePagesTitlesScreen(bloc: b),
  );
}
