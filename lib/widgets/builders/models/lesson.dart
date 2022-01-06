import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/repositories/gallery_lesson.dart';
import 'package:courseplease/widgets/builders/models/abstract.dart';
import 'package:flutter/widgets.dart';

import '../abstract.dart';

// Unused.
class LessonBuilderWidget extends StatelessWidget {
  final int id;
  final ValueFinalWidgetBuilder<Lesson> builder;

  LessonBuilderWidget({
    required this.id,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ModelBuilderWidget<int, Lesson, GalleryLessonRepository>(
      id: id,
      builder: builder,
    );
  }
}
