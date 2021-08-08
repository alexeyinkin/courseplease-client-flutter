import 'package:courseplease/models/filters/gallery_lesson.dart';
import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:flutter/material.dart';

import '../abstract_object_tile.dart';
import 'lesson_cover.dart';

class GalleryLessonTile extends AbstractObjectTile<int, Lesson, GalleryLessonFilter> {
  GalleryLessonTile({
    required TileCreationRequest<int, Lesson, GalleryLessonFilter> request,
  }) : super(
    request: request,
  );

  @override
  State<AbstractObjectTile> createState() => GalleryLessonTileState();
}

class GalleryLessonTileState extends AbstractObjectTileState<int, Lesson, GalleryLessonFilter, GalleryLessonTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      child: Column(
        children: [
          GestureDetector(
            onTap: _handleCoverTap,
            child: Container(
              padding: EdgeInsets.only(bottom: 5),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: LessonCoverWidget(
                  lesson: widget.object,
                  showPlayButton: true,
                ),
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
