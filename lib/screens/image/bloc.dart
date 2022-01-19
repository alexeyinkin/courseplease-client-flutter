import 'package:courseplease/blocs/page.dart';
import 'package:courseplease/router/page_configuration.dart';

import 'configurations.dart';

class ImageBloc extends AppPageBloc {
  final int imageId;
  final String subjectPath;

  ImageBloc({
    required this.imageId,
    required this.subjectPath,
  });

  @override
  MyPageConfiguration getConfiguration() {
    return ImagePageConfiguration(
      imageId: imageId,
      subjectPath: subjectPath,
    );
  }
}
