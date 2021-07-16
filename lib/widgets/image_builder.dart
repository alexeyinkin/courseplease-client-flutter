import 'package:courseplease/models/image.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/widgets/model_builder.dart';
import 'package:flutter/widgets.dart';

import 'builders/abstract.dart';

class ImageBuilderWidget extends StatelessWidget {
  final int id;
  final ValueFinalWidgetBuilder<ImageEntity> builder;
  final ImageEntity? defaultModel;

  ImageBuilderWidget({
    required this.id,
    required this.builder,
    this.defaultModel,
  });

  @override
  Widget build(BuildContext context) {
    return ModelBuilderWidget<int, ImageEntity, GalleryImageRepository>(
      id: id,
      builder: builder,
      defaultModel: defaultModel,
    );
  }
}
