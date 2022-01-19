import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/image/screen.dart';
import 'package:flutter/foundation.dart';

import 'bloc.dart';

class ImagePage extends BlocMaterialPage<MyPageConfiguration, ImageBloc> {
  static const factoryKey = 'ImagePage';

  ImagePage({
    required int imageId,
    required String subjectPath,
  }) : super(
    key: ValueKey(formatKey(imageId: imageId)),
    factoryKey: factoryKey,
    bloc: ImageBloc(
      imageId: imageId,
      subjectPath: subjectPath,
    ),
    createScreen: (b) => ImageScreen(bloc: b),
  );

  static String formatKey({required int imageId}) {
    return '${factoryKey}_$imageId';
  }
}
