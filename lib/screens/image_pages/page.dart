import 'package:app_state/app_state.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/filters/gallery_image.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:courseplease/screens/image_pages/screen.dart';
import 'package:flutter/foundation.dart';

import 'bloc.dart';

class ImagePagesGalleryPage extends BlocMaterialPage<
  ScreenConfiguration,
  ImagePagesGalleryBloc
> {
  ImagePagesGalleryPage({
    required GalleryImageFilter filter,
    required int initialIndex,
    required int initialId,
  }) : super(
    // TODO: Disregard initialIndex for filter, navigate to index
    //       if another instance of the page with another index
    //       is brought to front.
    key: ValueKey('ImagePagesGalleryPage_${filter}_$initialIndex'),
    bloc: ImagePagesGalleryBloc(
      filter: filter,
      initialIndex: initialIndex,
      initialId: initialId,
    ),
    createScreen: (b) => ImagePagesGalleryScreen(bloc: b),
  );
}

class ImagePagesTitlesPage<
  F extends AbstractFilter,
  R extends AbstractImageRepository<F>
> extends BlocMaterialPage<
  ScreenConfiguration,
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
