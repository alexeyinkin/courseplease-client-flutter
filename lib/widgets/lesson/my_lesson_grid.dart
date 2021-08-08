import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/repositories/my_lesson.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:flutter/rendering.dart';
import '../../screens/lesson/lesson.dart';
import '../../models/lesson.dart';
import '../object_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'my_lesson_tile.dart';

class MyLessonGrid extends StatefulWidget {
  final MyLessonFilter filter;
  final Axis scrollDirection;
  final int crossAxisCount;
  final SelectableListCubit<int, MyLessonFilter>? listStateCubit;
  final bool showStatusOverlay;
  final bool showMappingsOverlay;
  final Widget? titleIfNotEmpty;

  MyLessonGrid({
    required this.filter,
    required this.scrollDirection,
    required this.crossAxisCount,
    this.listStateCubit,
    this.showStatusOverlay = false,
    this.showMappingsOverlay = false,
    this.titleIfNotEmpty,
  }) : super(key: ValueKey(filter.toString()));

  @override
  State<MyLessonGrid> createState() {
    return new _MyLessonGridState();
  }
}

class _MyLessonGridState extends State<MyLessonGrid> {
  final padding = 10.0;

  @override
  Widget build(BuildContext context) {
    return _isFilterValid(widget.filter)
        ? _buildWithFilter()
        : Container();
  }

  static bool _isFilterValid(MyLessonFilter filter) {
    return true;
  }

  Widget _buildWithFilter() {
    return Container(
      padding: EdgeInsets.all(padding),
      child: ObjectGrid<int, Lesson, MyLessonFilter, MyLessonRepository, MyLessonTile>(
        filter: widget.filter,
        tileFactory: _createTile,
        titleIfNotEmpty: widget.titleIfNotEmpty,
        onTap: _handleTap,
        scrollDirection: widget.scrollDirection,
        listStateCubit: widget.listStateCubit,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          mainAxisSpacing: padding,
          crossAxisSpacing: padding,
          childAspectRatio: 1.2,
        ),
      ),
    );
  }

  MyLessonTile _createTile(TileCreationRequest<int, Lesson, MyLessonFilter> request) {
    return MyLessonTile(
      request: request,
      selectable: widget.listStateCubit != null,
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
