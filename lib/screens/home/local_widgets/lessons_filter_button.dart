import 'package:courseplease/models/filters/gallery_lesson.dart';
import 'package:courseplease/screens/explore/local_blocs/lessons_tab.dart';
import 'package:courseplease/screens/filter/local_blocs/gallery_lesson_filter.dart';
import 'package:courseplease/screens/filter/local_widgets/gallery_lesson_filter.dart';
import 'package:courseplease/services/filter_buttons/gallery_lesson_filter.dart';
import 'package:courseplease/widgets/filter_button.dart';
import 'package:flutter/material.dart';

class LessonsFilterButton extends StatelessWidget {
  final LessonsTabCubit cubit;

  LessonsFilterButton({
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return FilterButton<GalleryLessonFilter, GalleryLessonFilterDialogCubit>(
      filterableCubit: cubit,
      filterButtonService: GalleryLessonFilterButtonService(),
      dialogContentCubitFactory: () => GalleryLessonFilterDialogCubit(),
      dialogContentBuilder: (context, cubit) => GalleryLessonFilterDialogContentWidget(cubit: cubit),
      style: FilterButtonStyle.flat,
    );
  }
}
