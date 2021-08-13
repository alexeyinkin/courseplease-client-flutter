import 'package:courseplease/repositories/gallery_lesson.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:flutter/rendering.dart';
import '../../screens/lesson/lesson.dart';
import '../../models/filters/gallery_lesson.dart';
import '../../models/lesson.dart';
import '../object_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'gallery_lesson_tile.dart';

class GalleryLessonGrid extends StatefulWidget {
  GalleryLessonFilter filter;
  final Axis scrollDirection;
  final int crossAxisCount;
  Widget? titleIfNotEmpty;

  GalleryLessonGrid({
    required this.filter,
    required this.scrollDirection,
    required this.crossAxisCount,
    this.titleIfNotEmpty,
  }) : super(key: ValueKey(filter.subjectId));

  @override
  State<GalleryLessonGrid> createState() {
    return new _GalleryLessonGridState();
  }
}

class _GalleryLessonGridState extends State<GalleryLessonGrid> {
  final padding = 10.0;

  @override
  Widget build(BuildContext context) {
    return _isFilterValid(widget.filter)
        ? _buildWithFilter()
        : Container();
  }

  static bool _isFilterValid(GalleryLessonFilter filter) {
    return filter.subjectId != null;
  }

  Widget _buildWithFilter() {
    return Container(
      child: ObjectGrid<int, Lesson, GalleryLessonFilter, GalleryLessonRepository, GalleryLessonTile>(
        filter: widget.filter,
        tileFactory: _createTile,
        titleIfNotEmpty: widget.titleIfNotEmpty,
        onTap: _handleTap,
        scrollDirection: widget.scrollDirection,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          mainAxisSpacing: padding,
          crossAxisSpacing: padding,
          childAspectRatio: 1.2,
        ),
      ),
    );
  }

  GalleryLessonTile _createTile(TileCreationRequest<int, Lesson, GalleryLessonFilter> request) {
    return GalleryLessonTile(
      request: request,
    );
  }

  void _handleTap(Lesson lesson, int index) {
    LessonScreen.show(
      context: context,
      lessonId: lesson.id,
      autoplay: true, // TODO: No autoplay if tapped the title and not the cover.
    );
  }
}
