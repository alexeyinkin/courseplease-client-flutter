import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/lesson/lesson_cover.dart';
import 'package:flutter/material.dart';

import '../abstract_object_tile.dart';

class MyLessonTile extends AbstractObjectTile<int, Lesson, MyLessonFilter> {
  MyLessonTile({
    required TileCreationRequest<int, Lesson, MyLessonFilter> request,
    bool selectable = false,
  }) : super(
    request: request,
    selectable: selectable,
  );

  @override
  State<AbstractObjectTile> createState() => _MyLessonTileState();
}

class _MyLessonTileState extends AbstractObjectTileState<int, Lesson, MyLessonFilter, MyLessonTile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackground(),
        getCheckboxOverlay(),
      ]
    );
  }

  Widget _buildBackground() {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: _handleCoverTap,
            child: Container(
              padding: EdgeInsets.only(bottom: 5),
              child: LessonCoverWidget(
                lesson: widget.object,
                showPlayButton: false,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _handleTitleTap,
                  child: Text(
                    widget.object.title,
                    style: AppStyle.lessonTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleCoverTap() {
    _handleTap();
  }

  void _handleTitleTap() {
    _handleTap();
  }

  void _handleTap() {
    widget.onTap();
  }
}
